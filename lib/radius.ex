defmodule Radius do
  alias Radius.Packet

  @doc """
    wrapper of gen_udp.open
  """
  def listen(port) do
    :gen_udp.open(port, [{:active, :false}, {:mode, :binary}])
  end

  @doc """
    recv and decode packet.

        sk :: socket
        secret :: string | fn({host,port}) -> string
  """
  def recv(sk, secret) when is_binary(secret) do
    recv(sk, fn(_) -> secret end)
  end
  def recv(sk, secret_fn) when is_function(secret_fn) do
    {:ok, {host, port, data}} = :gen_udp.recv(sk, 5000)
    secret = secret_fn.({host, port})
    packet = Packet.decode(data, secret)
    {:ok, {host, port}, packet}
  end

  @doc """
    encode and send packet

        sk :: socket
        packet:: %Radius.Packet{}
  """
  def send(sk, {host, port}, packet) do
    data = Packet.encode(packet)
    :gen_udp.send(sk, host, port, data)
  end
end
