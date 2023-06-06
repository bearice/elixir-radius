defmodule Radius.Packet do
  require Logger

  alias __MODULE__
  alias Radius.Dict
  alias Radius.Dict.EntryNotFoundError

  @default_format {1, 1}

  @type t :: %{
          code: String.t(),
          id: integer(),
          length: integer(),
          auth: binary(),
          attrs: keyword(),
          raw: iolist(),
          secret: binary()
        }
  defstruct code: nil,
            id: nil,
            length: nil,
            auth: nil,
            attrs: [],
            raw: nil,
            secret: nil

  @doc """
  Decode radius packet
  """
  def decode(data, secret) do
    pkt =
      %{raw: data, secret: secret, attrs: nil}
      |> decode_header
      |> decode_payload

    struct(__MODULE__, pkt)
  end

  defp decode_header(%{raw: raw} = ctx) do
    <<code, id, length::size(16), auth::binary-size(16), rest::binary>> = raw

    if byte_size(rest) < length - 20 do
      {:error, :packet_too_short}
    else
      if byte_size(ctx.raw) != length do
        raise "Packet length not match."
      end

      ctx
      |> Map.merge(%{
        code: decode_code(code),
        id: id,
        length: length,
        auth: auth,
        rest: rest
      })
    end
  end

  defp decode_code(1), do: "Access-Request"
  defp decode_code(2), do: "Access-Accept"
  defp decode_code(3), do: "Access-Reject"
  defp decode_code(11), do: "Access-Challenge"
  defp decode_code(4), do: "Accounting-Request"
  defp decode_code(5), do: "Accounting-Response"
  defp decode_code(12), do: "Status-Server"
  defp decode_code(13), do: "Status-Client"
  defp decode_code(x), do: x

  defp decode_payload(ctx) do
    decode_tlv(ctx.rest)
    |> resolve_tlv(ctx)
  end

  defp decode_tlv(bin, acc \\ [], format \\ @default_format)

  defp decode_tlv(<<>>, acc, _), do: acc |> Enum.reverse()
  # not to decode USR style VSAs
  defp decode_tlv(bin, _, {_, 0}), do: bin

  defp decode_tlv(bin, acc, {tl, ll} = fmt) when byte_size(bin) > tl + ll do
    tl = tl * 8
    ll = ll * 8
    <<type::integer-size(tl), length::integer-size(ll), rest::binary>> = bin
    length = length - 2
    <<value::binary-size(length), rest::binary>> = rest
    decode_tlv(rest, [{type, value} | acc], fmt)
  end

  defp resolve_tlv(attrs, ctx) when is_list(attrs) do
    attrs = attrs |> Enum.map(&resolve_tlv(&1, ctx, nil))
    Map.put(ctx, :attrs, attrs)
  end

  # VSA Entry
  defp resolve_tlv({26, value}, ctx, nil) do
    type = "Vendor-Specific"
    <<vid::size(32), rest::binary>> = value

    try do
      v = Dict.vendor_by_id(vid)

      value =
        case decode_tlv(rest, [], v.format) do
          bin when is_binary(bin) ->
            bin

          tlv when is_list(tlv) ->
            Enum.map(tlv, fn x ->
              resolve_tlv(x, ctx, v)
            end)
        end

      {{type, v.name}, value}
    rescue
      _e in EntryNotFoundError ->
        {type, value}
    end
  end

  defp resolve_tlv({type, value} = tlv, ctx, vendor) do
    try do
      attr = vendor_attribute_by_id(vendor, type)
      has_tag = Keyword.has_key?(attr.opts, :has_tag)

      {tag, value} =
        case value do
          <<0, rest::binary>> when has_tag == true ->
            {nil, rest}

          <<tag, rest::binary>> when tag in 1..0x1F and has_tag == true ->
            {tag, rest}

          _ ->
            {nil, value}
        end

      value =
        value
        |> decode_value(attr.type)
        |> resolve_value(vendor, attr.name)
        |> decrypt_value(Keyword.get(attr.opts, :encrypt), ctx.auth, ctx.secret)

      if tag do
        {attr.name, {tag, value}}
      else
        {attr.name, value}
      end
    rescue
      _e in EntryNotFoundError ->
        tlv
    end
  end

  defp decode_value(<<val::integer-size(8)>>, :byte), do: val
  defp decode_value(<<val::integer-size(16)>>, :short), do: val
  defp decode_value(<<val::integer-size(32)>>, :integer), do: val
  defp decode_value(<<val::integer-size(32)-signed>>, :signed), do: val
  defp decode_value(<<val::integer-size(32)>>, :date), do: val
  defp decode_value(<<val::integer-size(64)>>, :ifid), do: val
  defp decode_value(<<a, b, c, d>>, :ipaddr), do: {a, b, c, d}

  defp decode_value(<<bin::binary-size(16)>>, :ipv6addr) do
    for(<<x::integer-size(16) <- bin>>, do: x) |> :erlang.list_to_tuple()
  end

  defp decode_value(bin, _t) do
    bin
  end

  defp resolve_value(val, vendor, attr_name) do
    try do
      if vendor do
        v = vendor.module().value_by_value(attr_name, val)
        v.name
      else
        v = Dict.value_by_value(attr_name, val)
        v.name
      end
    rescue
      _e in EntryNotFoundError ->
        val
    end
  end

  defp decrypt_value(bin, nil, _, _), do: bin

  defp decrypt_value(bin, 1, auth, secret) do
    Radius.Util.decrypt_rfc2865(bin, secret, auth)
  end

  defp decrypt_value(bin, 2, auth, secret) do
    Radius.Util.decrypt_rfc2868(bin, secret, auth)
  end

  defp decrypt_value(bin, a, _, _) do
    Logger.error("Unknown encrypt type: #{inspect(a)}")
    bin
  end

  @doc """
    Return an iolist of encoded packet

    for request packets, leave packet.auth == nil, then I will generate one from random bytes.
    for reply packets, set packet.auth = request.auth, I will calc the reply hash with it.

        packet.attrs :: [attr]
        attr :: {type,value}
        type :: String.t | integer | {"Vendor-Specific", vendor}
        value :: integer | String.t | ipaddr
        vendor :: String.t | integer
        ipaddr :: {a,b,c,d} | {a,b,c,d,e,f,g,h}

  """
  @deprecated "Use encode_request/1-2 or encode_reply/1-2 instead"
  def encode(packet, options \\ []) do
    packet =
      if packet.auth == nil do
        encode_request(packet, options)
      else
        encode_reply(packet, packet.auth, options)
      end

    packet.raw
  end

  @doc """
  Encode the request packet into an iolist and put the result in the `:raw` key. The `:auth` key will contain
  the authenticator used on the request.
  """
  @spec encode_request(packet :: Packet.t(), options :: keyword()) :: Packet.t()
  def encode_request(packet, options \\ []) do
    packet = %{packet | auth: :crypto.strong_rand_bytes(16)}
    {header, attrs} = encode_packet(packet, options)

    %{packet | raw: [header, attrs]}
  end

  @doc """
  Encode the reply packet into an iolist and put the result in the `:raw` key. The `:auth` key needs
  to be filled with the authenticator of the request packet.
  """
  @spec encode_reply(
          packet :: Packet.t(),
          request_authenticator :: binary(),
          options :: keyword()
        ) :: Packet.t()
  def encode_reply(packet, request_authenticator, options \\ []) do
    packet = %{packet | auth: request_authenticator}
    {header, attrs} = encode_packet(packet, options)

    resp_auth = :crypto.hash(:md5, [header, attrs, packet.secret])

    header = <<header::bytes-size(4), resp_auth::binary>>

    %{packet | auth: resp_auth, raw: [header, attrs]}
  end

  defp encode_packet(packet, options) do
    sign? = options |> Keyword.get(:sign, false)

    packet =
      if sign? do
        attrs = [{"Message-Authenticator", <<0::size(128)>>} | packet.attrs]

        %{packet | attrs: attrs}
      else
        packet
      end

    attrs = encode_attrs(packet)

    code = encode_code(packet.code)
    length = 20 + IO.iodata_length(attrs)
    header = <<code, packet.id, length::size(16), packet.auth::binary>>

    attrs =
      if sign? do
        signature = message_authenticator(packet.secret, [header, attrs])
        [<<t, l, _::binary>> | rest_attrs] = attrs
        [<<t, l, signature::binary>> | rest_attrs]
      else
        attrs
      end

    {header, attrs}
  end

  defp message_authenticator(secret, msg) do
    :crypto.mac(:hmac, :md5, secret, msg)
  end

  defp encode_attrs(%{attrs: a} = ctx) do
    Enum.map(a, fn x ->
      x |> resolve_attr(ctx) |> encode_attr
    end)
  end

  defp encode_attr(attr, format \\ @default_format)
  # back-door for VSAs, encode_vsa could retuen an iolist
  defp encode_attr({26, value}, _), do: [26, :erlang.iolist_size(value) + 2, value]

  defp encode_attr({tag, value}, _) when is_binary(value) do
    len = byte_size(value) + 2

    if len > 0xFF do
      raise "value oversized: #{inspect({tag, value})}"
    end

    <<tag, len, value::binary>>
  end

  defp encode_attr({tag, value}, _) when is_integer(value) do
    if value > 0xFFFFFFFF do
      Logger.warn("value truncated: #{inspect({tag, value})}")
    end

    <<tag, 6, value::integer-size(32)>>
  end

  defp encode_attr({type, value, attr}, {t, l}) do
    value =
      if Keyword.has_key?(attr.opts, :has_tag) do
        {tag, value} =
          case value do
            {tag, value} when tag in 0..0x1F -> {tag, value}
            {tag, _value} -> raise "Tag over-range, should be [0-0x1f], got: #{tag}"
            value -> {0, value}
          end

        value = encode_value(value, attr.type)
        <<tag, value::binary>>
      else
        encode_value(value, attr.type)
      end

    length = byte_size(value) + t + l
    ll = l * 8
    tl = t * 8
    <<type::integer-size(tl), length::integer-size(ll), value::binary>>
  end

  defp encrypt_value({tag, bin}, attr, ctx), do: {tag, encrypt_value(bin, attr, ctx)}

  defp encrypt_value(bin, attr, ctx),
    do: encrypt_value(bin, Keyword.get(attr.opts, :encrypt), ctx.auth, ctx.secret)

  defp encrypt_value(bin, nil, _, _), do: bin

  defp encrypt_value(bin, 1, auth, secret) do
    Radius.Util.encrypt_rfc2865(bin, secret, auth)
  end

  defp encrypt_value(bin, 2, auth, secret) do
    Radius.Util.encrypt_rfc2868(bin, secret, auth)
  end

  defp encrypt_value(bin, a, _, _) do
    Logger.error("Unknown encrypt type: #{inspect(a)}")
    bin
  end

  defp encode_value(val, :byte) when is_integer(val), do: <<val::size(8)>>
  defp encode_value(val, :short) when is_integer(val), do: <<val::size(16)>>
  defp encode_value(val, :integer) when is_integer(val), do: <<val::size(32)>>
  defp encode_value(val, :signed) when is_integer(val), do: <<val::size(32)-signed>>
  defp encode_value(val, :date) when is_integer(val), do: <<val::size(32)>>
  defp encode_value(val, :ifid) when is_integer(val), do: <<val::size(64)>>
  defp encode_value({a, b, c, d}, :ipaddr), do: <<a, b, c, d>>
  defp encode_value(x, :ipaddr) when is_integer(x), do: <<x::size(32)>>

  defp encode_value(x, :ipv6addr) when is_tuple(x) and tuple_size(x) == 8 do
    for x <- :erlang.tuple_to_list(x), into: "", do: <<x::size(16)>>
  end

  defp encode_value(bin, _), do: bin

  defp resolve_attr({{type, vid}, value}, ctx) when type == "Vendor-Specific" or type == 26 do
    {26, encode_vsa(vid, value, ctx)}
  end

  defp resolve_attr(tlv, ctx) do
    resolve_attr(tlv, ctx, nil)
  end

  defp resolve_attr({type, value}, ctx, vendor) do
    case lookup_attr(vendor, type) do
      nil -> {type, value}
      a -> {a.id, lookup_value(a, value, vendor) |> encrypt_value(a, ctx), a}
    end
  end

  defp lookup_attr(vendor, type) when is_integer(type) do
    try do
      vendor_attribute_by_id(vendor, type)
    rescue
      _e in EntryNotFoundError -> nil
    end
  end

  # Raise an error if attr not defined
  defp lookup_attr(vendor, type) when is_binary(type) do
    vendor_attribute_by_name(vendor, type)
  end

  defp lookup_value(attr, {tag, val}, vendor) do
    {tag, lookup_value(attr, val, vendor)}
  end

  defp lookup_value(%{type: :integer} = attr, val, vendor) when is_binary(val) do
    try do
      if vendor do
        v = vendor.module().value_by_name(attr.name, val)
        v.value
      else
        v = Dict.value_by_name(attr.name, val)
        v.value
      end
    rescue
      _e in EntryNotFoundError ->
        # raise "Value can not be resolved: #{attr.name}: #{val}"
        val
    end
  end

  defp lookup_value(_, val, _), do: val

  defp encode_vsa(vid, value, ctx) when is_binary(value) and is_binary(vid),
    do: encode_vsa(Dict.vendor_by_name(vid).id, value, ctx)

  defp encode_vsa(vid, value, _) when is_binary(value) and is_integer(vid),
    do: <<vid::size(32), value::binary>>

  defp encode_vsa(vid, vsa, ctx) when is_tuple(vsa), do: encode_vsa(vid, [vsa], ctx)

  defp encode_vsa(vid, vsa, ctx) when is_binary(vid),
    do: encode_vsa(Dict.vendor_by_name(vid), vsa, ctx)

  defp encode_vsa(vid, vsa, ctx) when is_integer(vid),
    do: encode_vsa(Dict.vendor_by_id(vid), vsa, ctx)

  defp encode_vsa(vendor, vsa, ctx) do
    IO.inspect(vendor)

    val =
      Enum.map(vsa, fn x ->
        x |> resolve_attr(ctx, vendor) |> encode_attr(vendor.format)
      end)

    [<<vendor.id::size(32)>> | val]
  end

  defp encode_code(x) when is_integer(x), do: x
  defp encode_code("Access-Request"), do: 1
  defp encode_code("Access-Accept"), do: 2
  defp encode_code("Access-Reject"), do: 3
  defp encode_code("Access-Challenge"), do: 11
  defp encode_code("Accounting-Request"), do: 4
  defp encode_code("Accounting-Response"), do: 5
  defp encode_code("Status-Server"), do: 12
  defp encode_code("Status-Client"), do: 13

  defp vendor_attribute_by_id(nil, id) do
    Dict.attribute_by_id(id)
  end

  defp vendor_attribute_by_id(vendor, id) do
    with %{module: mod} <- Dict.vendor_by_id(vendor.id) do
      mod.attribute_by_id(id)
    end
  end

  defp vendor_attribute_by_name(nil, name) do
    Dict.attribute_by_name(name)
  end

  defp vendor_attribute_by_name(vendor, name) do
    with %{module: mod} <- Dict.vendor_by_id(vendor.id) do
      mod.attribute_by_name(name)
    end
  end

  @doc """
  Return the value of a given attribute, if found, or default otherwise.
  """
  def get_attr(packet, attr_name) do
    for {^attr_name, value} <- packet.attrs, do: value
  end

  @doc """
  Verify if the packet signature is valid.

  (https://www.ietf.org/rfc/rfc2865.txt)
  (https://www.ietf.org/rfc/rfc2869.txt)
  """
  def verify(packet) do
    verify(packet, packet.auth)
  end

  def verify(packet, request_authenticator) do
    case Radius.Packet.get_attr(packet, "Message-Authenticator") do
      [sig1] ->
        {header, attrs} = encode_packet(%{packet | auth: request_authenticator}, [])
        resp_auth = :crypto.hash(:md5, [header, attrs, packet.secret])

        attrs =
          Enum.map(packet.attrs, fn
            {"Message-Authenticator", _} -> {"Message-Authenticator", <<0::size(128)>>}
            attr -> attr
          end)

        packet = %{packet | attrs: attrs}
        {header, attrs} = encode_packet(packet, [])
        <<code, id, length::size(16), _resp_auth::binary>> = header
        sign_header = <<code, id, length::size(16), request_authenticator::binary>>
        sig2 = message_authenticator(packet.secret, [sign_header, attrs])

        (packet.auth == request_authenticator or packet.auth == resp_auth) and sig1 == sig2

      _ ->
        {header, attrs} = encode_packet(%{packet | auth: request_authenticator}, [])
        resp_auth = :crypto.hash(:md5, [header, attrs, packet.secret])

        packet.auth == request_authenticator or packet.auth == resp_auth
    end
  end
end
