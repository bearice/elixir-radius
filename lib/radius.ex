defmodule Radius do
  require Logger
  defmodule Packet do
    defstruct code: nil, id: nil, length: nil, auth: nil, attrs: nil
    def decode(data,_secret) do
      #Logger.debug inspect data
      decode_header(data)
    end #def decode/2

    def decode_header(<<code, id, length :: size(16), auth ::binary-size(16), rest :: binary>>) do
      #Logger.debug inspect {length, byte_size rest}
      if byte_size(rest) < length-20 do
        {:error,:packet_too_short}
      else
        attrs = decode_tlv([],rest)
        %Packet {code: code, id: id, length: length, auth: auth, attrs: attrs}
      end
    end
    def decode_header(_,_) do
      {:error, :malformed_packet}
    end #def decode_header/2


    def decode_tlv(acc,<<>>) do
      Enum.reverse(acc)
    end
    def decode_tlv(acc,<<type, length, value_rest :: binary>>) do
      length = length - 2
      <<value :: binary-size(length),rest::binary>> = value_rest
      decode_tlv([{type, length, value}|acc],rest)
    end #def decode_tlv/2


    def encode(_packet,_secret) do
      <<>>
    end
  end #defmodule Packet

  def listen(port) do
    :gen_udp.open(port,[{:active,:false},{:mode,:binary}])
  end

  def recv(sk) do
    {:ok,{_add,_port,data}} = :gen_udp.recv sk,10000
    Packet.decode data,nil
  end

  def send(sk,packet) do
    data = Packet.encode packet,nil
    sk.send! data
  end
end

