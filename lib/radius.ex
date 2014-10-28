defmodule Radius do
  alias RadiusDict.Attribute
  alias RadiusDict.Vendor
  alias RadiusDict.Value
  require Logger
  defmodule Packet do
    defstruct code: nil, id: nil, length: nil, auth: nil, attrs: nil
    def decode(data,secret) do
      pkt = %{rest: data, secret: secret} 
        |> decode_header
        |> decode_payload
      struct Packet,pkt

    end #def decode/2

    defp decode_header(%{rest: <<code, id, length :: size(16), auth ::binary-size(16), rest :: binary>>, secret: secret}) do
      if byte_size(rest) < length-20 do
        {:error,:packet_too_short}
      else
        %{code: code, id: id, length: length, auth: auth, rest: rest, attrs: nil, secret: secret}
      end
    end

    defp decode_payload(pkt) do
      decode_attr(pkt.rest,[]) |> resolve_attr pkt
    end

    defp decode_attr(<<>>,acc), do: acc
    defp decode_attr(<<type, length, value_rest :: binary>>,acc) do
      length = length - 2
      <<value :: binary-size(length),rest::binary>> = value_rest
      decode_attr(rest,[{type, length, value}|acc])
    end #def decode_attr/2

    defp resolve_attr(attrs,ctx) when is_list(attrs) do
      attrs = Enum.map attrs, fn(x)->
        resolve_tlv x,ctx,nil
      end
      %{ctx| attrs: attrs} 
    end

    defp resolve_tlv({type,len,value}=tlv, ctx, vendor\\nil) do
      try do
        attr = Attribute.lookup! {:id,{vendor,type}}
        type = attr.name
        if Keyword.has_key? attr.opts, :has_tag do
          <<tag,rest::binary>> = value
          if tag in 0..0x1f do
            value = rest
            type = {type,tag}
          end
        end
        value = value 
                |> decode_value(attr.type)
                |> resolve_value(vendor,attr.id)
                |> decrypt_value(Keyword.get(attr.opts, :encrypt), ctx.auth, ctx.secret)

        {type,len,value}
      rescue e ->
          Logger.error Exception.message e
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
    defp decode_value(bin,_), do: bin

    defp resolve_value(val,vid,aid) do
      try do
        v = Value.lookup! {:id,{vid,aid,val}}
        v.name
      rescue e ->
        val
      end
    end
    defp decrypt_value(bin,nil,_,_), do: bin
    defp decrypt_value(bin,1,auth,secret) do
      RadiusUtil.decrypt_rfc2865 bin,secret,auth
    end
    defp decrypt_value(bin,a,_,_) do
      Logger.error "Unknown encrypt tag: #{inspect a}"
      bin
    end

    def encode(_packet,_secret) do
      <<>>
    end
  end #defmodule Packet

  def listen(port) do
    :gen_udp.open(port,[{:active,:false},{:mode,:binary}])
  end

  def recv(sk,secret) do
    {:ok,{_add,_port,data}} = :gen_udp.recv sk,10000
    Packet.decode data,secret
  end

  def send(sk,packet) do
    data = Packet.encode packet,nil
    sk.send! data
  end
end

