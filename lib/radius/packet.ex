defmodule Radius.Packet do
  require Logger

  alias Radius.Dict.Attribute
  alias Radius.Dict.Vendor
  alias Radius.Dict.Value
  alias Radius.Dict.EntryNotFoundError

  defstruct [
    code: nil,
    id: nil,
    length: nil,
    auth: nil,
    attrs: [],
    raw: nil,
    secret: nil,
  ]

  @doc """
  Decode radius packet
  """
  def decode(data, secret) do
    pkt = %{raw: data, secret: secret, attrs: nil}
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
      ctx |> Map.merge(%{
        code: decode_code(code),
        id: id,
        length: length,
        auth: auth,
        rest: rest
      })
    end
  end

  defp decode_code(1),  do: "Access-Request"
  defp decode_code(2),  do: "Access-Accept"
  defp decode_code(3),  do: "Access-Reject"
  defp decode_code(11), do: "Access-Challenge"
  defp decode_code(4),  do: "Accounting-Request"
  defp decode_code(5),  do: "Accounting-Response"
  defp decode_code(12), do: "Status-Server"
  defp decode_code(13), do: "Status-Client"
  defp decode_code(x),  do: x

  defp decode_payload(ctx) do
    decode_tlv(ctx.rest, [], {1, 1})
    |> resolve_tlv(ctx)
  end

  defp decode_tlv(<<>>, acc, _), do: acc |> Enum.reverse()
  defp decode_tlv(bin, _, {_, 0}), do: bin # not to decode USR style VSAs
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
    Map.put ctx, :attrs, attrs
  end

  #VSA Entry
  defp resolve_tlv({26,value}, ctx, nil) do
    type = "Vendor-Specific"
    <<vid::size(32),rest::binary>>=value
    try do
      v = Vendor.by_id vid
      value = case decode_tlv rest,[],v.format do
        bin when is_binary(bin) -> bin
        tlv when is_list(tlv) ->
          Enum.map tlv, fn(x) ->
            resolve_tlv(x,ctx,v.id)
          end
      end
      {{type,v.name},value}
    rescue _e in EntryNotFoundError ->
      {type,value}
    end
  end

  defp resolve_tlv({type, value} = tlv, ctx, vendor) do
    try do
      attr = Attribute.by_id vendor,type
      type = attr.name
      has_tag = Keyword.has_key? attr.opts, :has_tag
      {tag, value} = case value do
        <<0,rest::binary>> when has_tag==true ->
          {nil, rest}

        <<tag,rest::binary>> when tag in 1..0x1f and has_tag==true ->
          {tag, rest}

        _ ->
          {nil, value}
      end

      value = value
              |> decode_value(attr.type)
              |> resolve_value(vendor,attr.id)
              |> decrypt_value(Keyword.get(attr.opts, :encrypt), ctx.auth, ctx.secret)

      if tag do
        {type,{tag,value}}
      else
        {type,value}
      end
    rescue _e in EntryNotFoundError->
        tlv
    end
  end

  defp decode_value(<<val :: integer-size(8)>>,:byte), do: val
  defp decode_value(<<val :: integer-size(16)>>,:short), do: val
  defp decode_value(<<val :: integer-size(32)>>,:integer), do: val
  defp decode_value(<<val :: integer-size(32)-signed>>,:signed), do: val
  defp decode_value(<<val :: integer-size(32)>>,:date), do: val
  defp decode_value(<<val :: integer-size(64)>>,:ifid), do: val
  defp decode_value(<<a,b,c,d>>,:ipaddr), do: {a,b,c,d}
  defp decode_value(<<bin :: binary-size(16)>>,:ipv6addr) do
    (for <<x::integer-size(16) <-bin >>, do: x) |> :erlang.list_to_tuple
  end
  defp decode_value(bin,_t) do
    bin
  end

  defp resolve_value(val,vid,aid) do
    try do
      v = Value.by_value vid,aid,val
      v.name
    rescue _e in EntryNotFoundError ->
      val
    end
  end
  defp decrypt_value(bin,nil,_,_), do: bin
  defp decrypt_value(bin,1,auth,secret) do
    Radius.Util.decrypt_rfc2865 bin,secret,auth
  end
  defp decrypt_value(bin,2,auth,secret) do
    Radius.Util.decrypt_rfc2868 bin,secret,auth
  end
  defp decrypt_value(bin,a,_,_) do
    Logger.error "Unknown encrypt type: #{inspect a}"
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
  def encode(packet, options \\ []) do
    sign? = options |> Keyword.get(:sign, false)
    raw? = options |> Keyword.get(:raw, false)
    {auth, reply?} = if packet.auth == nil do
      {:crypto.strong_rand_bytes(16), false}
    else
      {packet.auth, true}
    end

    packet = if sign? do
      attrs =
        packet.attrs ++ [
          {"Message-Authenticator", <<0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0>>}
        ]
      %{packet | attrs: attrs}
    else
      packet
    end

    attrs = encode_attrs(packet)

    code = encode_code(packet.code)
    length = 20 + :erlang.iolist_size(attrs)
    header = <<code, packet.id, length::size(16), auth::binary>>

    attrs = if sign? do
      signature = :crypto.hmac(:md5, packet.secret, [header, attrs])
      [last | attrs] = attrs |> Enum.reverse()
      crop_len = byte_size(last) - 16
      last = <<last::bytes-size(crop_len), signature::binary>>
      [last | attrs] |> Enum.reverse()
    else
      attrs
    end

    header = if reply? and raw? == false do
      resp_auth =
        :crypto.hash_init(:md5)
        |> :crypto.hash_update(header)
        |> :crypto.hash_update(attrs)
        |> :crypto.hash_update(packet.secret)
        |> :crypto.hash_final()
      <<header::bytes-size(4), resp_auth::binary>>
    else
      header
    end

    [header, attrs]
  end

  defp encode_attrs(%{attrs: a}=ctx) do
    Enum.map a, fn(x) ->
      x |> resolve_attr(ctx) |> encode_attr
    end
  end

  #back-door for VSAs, encode_vsa could retuen an iolist
  defp encode_attr({26,value}), do: [26,:erlang.iolist_size(value)+2,value]
  defp encode_attr({tag,value}) when is_binary(value) do
    len = byte_size(value) + 2
    if len > 0xff do
      raise "value oversized: #{inspect {tag,value}}"
    end
    <<tag,len,value::binary>>
  end
  defp encode_attr({tag,value}) when is_integer(value) do
    if value > 0xFFFFFFFF do
      Logger.warn "value truncated: #{inspect {tag,value}}"
    end
    <<tag,6,value::integer-size(32)>>
  end
  defp encode_attr({type,value,attr}) do
    {t,l}=attr.vendor.format
    value = if Keyword.has_key? attr.opts, :has_tag do
      {tag,value} = case value do
        {tag,value} when tag in 0..0x1f -> {tag,value}
        {tag,_value} -> raise "Tag over-range, should be [0-0x1f], got: #{tag}"
        value -> {0,value}
      end
      value = encode_value(value,attr.type)
      <<tag,value::binary>>
    else
      encode_value(value,attr.type)
    end
    length = byte_size(value) + t + l
    ll = l*8
    tl = t*8
    <<type :: integer-size(tl), length :: integer-size(ll), value :: binary>>
  end

  defp encrypt_value({tag,bin},attr,ctx), do: {tag,encrypt_value(bin,attr,ctx)}
  defp encrypt_value(bin,attr,ctx), do: encrypt_value(bin,Keyword.get(attr.opts,:encrypt),ctx.auth,ctx.secret)
  defp encrypt_value(bin,nil,_,_), do: bin
  defp encrypt_value(bin,1,auth,secret) do
    Radius.Util.encrypt_rfc2865 bin,secret,auth
  end
  defp encrypt_value(bin,2,auth,secret) do
    Radius.Util.encrypt_rfc2868 bin,secret,auth
  end
  defp encrypt_value(bin,a,_,_) do
    Logger.error "Unknown encrypt type: #{inspect a}"
    bin
  end


  defp encode_value(val,:byte)    when is_integer(val), do: <<val::size(8)>>
  defp encode_value(val,:short)   when is_integer(val), do: <<val::size(16)>>
  defp encode_value(val,:integer) when is_integer(val), do: <<val::size(32)>>
  defp encode_value(val,:signed)  when is_integer(val), do: <<val::size(32)-signed>>
  defp encode_value(val,:date)    when is_integer(val), do: <<val::size(32)>>
  defp encode_value(val,:ifid)    when is_integer(val), do: <<val::size(64)>>
  defp encode_value({a,b,c,d},:ipaddr), do: <<a,b,c,d>>
  defp encode_value(x,:ipaddr) when is_integer(x), do: <<x::size(32)>>
  defp encode_value(x,:ipv6addr) when is_tuple(x) and tuple_size(x) == 8 do
    for x <- :erlang.tuple_to_list(x), into: "", do: <<x::size(16)>>
  end
  defp encode_value(bin,_), do: bin


  defp resolve_attr({{type,vid},value},ctx) when type=="Vendor-Specific" or type == 26 do
    {26,encode_vsa(vid,value,ctx)}
  end

  defp resolve_attr(tlv,ctx) do
    resolve_attr(tlv,ctx,%Vendor{})
  end

  defp resolve_attr({type,value},ctx,vendor) do
    case lookup_attr(vendor,type) do
      nil -> {type,value}
      a   -> {a.id,lookup_value(a,value)|>encrypt_value(a,ctx),a}
    end
  end

  defp lookup_attr(vendor,type) when is_integer(type) do
    try do
      Attribute.by_id vendor.id,type
    rescue
      _e in EntryNotFoundError -> nil
    end
  end
  #Raise an error if attr not defined
  defp lookup_attr(_vendor,type) when is_binary(type) do
    Attribute.by_name type
  end

  defp lookup_value(attr,{tag,val}) do
    {tag,lookup_value(attr,val)}
  end
  defp lookup_value(%{type: :integer}=attr,val) when is_binary(val) do
    try do
      v = Value.by_name attr.vendor.name,attr.name,val
      v.value
    rescue _e in EntryNotFoundError->
      #raise "Value can not be resolved: #{attr.name}: #{val}"
      val
    end
  end
  defp lookup_value(_,val), do: val

  defp encode_vsa(vid,value,ctx) when is_binary(value) and is_binary(vid), do: encode_vsa(Vendor.by_name(vid).id,value,ctx)
  defp encode_vsa(vid,value,_) when is_binary(value) and is_integer(vid), do: <<vid::size(32),value>>
  defp encode_vsa(vid,vsa,ctx) when is_tuple(vsa), do: encode_vsa(vid, [vsa], ctx)
  defp encode_vsa(vid,vsa,ctx) when is_binary(vid), do: encode_vsa(Vendor.by_name(vid), vsa, ctx)
  defp encode_vsa(vid,vsa,ctx) when is_integer(vid), do: encode_vsa(Vendor.by_id(vid), vsa, ctx)
  defp encode_vsa(vendor, vsa, ctx) do
    val = Enum.map vsa, fn(x) ->
      x|> resolve_attr(ctx,vendor) |> encode_attr
    end
    [<<vendor.id::size(32)>>|val]
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

  @doc """
  Return the value of a given attribute, if found, or default otherwise.
  """
  def get_attr(packet, attr_name, default \\ nil) do
    result =
      packet.attrs
      |> Enum.find(default, fn
        {^attr_name, _} -> true
        _ -> false
      end)

    case result do
      {_, value} -> value
      _ -> nil
    end
  end

  @doc """
  Verify if the packet signature is valid.
  """
  def verify(packet) do
    # TODO: this code is going to fail when validating replies
    sig1 =
      packet
      |> Radius.Packet.get_attr("Message-Authenticator")

    if sig1 != nil do
      attrs =
        packet.attrs
        |> Enum.filter(fn {k, _} -> k != "Message-Authenticator" end)

      raw =
        %{packet | attrs: attrs}
        |> Radius.Packet.encode(raw: true, sign: true)
        |> IO.iodata_to_binary

      crop_len = byte_size(raw) - 16
      <<_::bytes-size(crop_len), sig2::binary>> = raw

      sig1 == sig2
    else
      false
    end
  end
end #defmodule Packet
