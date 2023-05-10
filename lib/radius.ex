defmodule Radius do
  alias Radius.Packet

  @doc """
    wrapper of gen_udp.open
  """
  def listen(port) do
    :gen_udp.open(port, [{:active, false}, {:mode, :binary}])
  end

  @doc """
    recv and decode packet.

        sk :: socket
        secret :: string | fn({host,port}) -> string
  """
  def recv(sk, secret) when is_binary(secret) do
    recv(sk, fn _ -> secret end)
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
  @deprecated "Use send_reply/4 or send_request/3"
  def send(sk, {host, port}, packet) do
    send_reply(sk, {host, port}, packet, packet.auth)
  end

  @doc """
  encode and send reply packet
  """
  @spec send_reply(
          socket :: port(),
          {host :: :inet.ip_address(), port :: :inet.port_number()},
          packet :: Packet.t(),
          request_authenticator :: binary()
        ) :: :ok | {:error, any()}
  def send_reply(sk, {host, port}, packet, request_authenticator) do
    %{raw: data} = Packet.encode_reply(packet, request_authenticator)
    :gen_udp.send(sk, host, port, data)
  end

  @doc """
  encode and send request packet
  """
  @spec send_request(
          socket :: port(),
          {host :: :inet.ip_address(), port :: :inet.port_number()},
          packet :: Packet.t()
        ) :: :ok | {:error, any()}
  def send_request(sk, {host, port}, packet) do
    %{raw: data} = Packet.encode_request(packet)
    :gen_udp.send(sk, host, port, data)
  end
end
