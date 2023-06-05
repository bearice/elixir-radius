require Logger
use Radius.Dict

# IO.puts inspect Radius.Dict.vendor_by_name("Cisco")
# IO.puts inspect Radius.Dict.attribute_by_name("Service-Type")
# IO.puts inspect Radius.Dict.value_by_name("Service-Type","Login-User")
# IO.puts inspect Radius.Dict.value_by_value("Service-Type",11)
# IO.puts inspect Radius.Dict.VendorCisco.value_by_name("Cisco-Disconnect-Cause","Unknown")
# IO.puts inspect Radius.Dict.VendorCisco.value_by_value("Cisco-Disconnect-Cause",11)

secret = "112233"

attrs = [
  attr_User_Password("1234"),
  # tagged attribute (rfc2868)
  attr_Tunnel_Type(val_Tunnel_Type_PPTP()),
  # equals
  {attr_Tunnel_Type(), {0, "PPTP"}},
  attr_Tunnel_Type({10, "PPTP"}),
  {attr_Service_Type(), "Login-User"},
  # tag & value can be integer
  {6, 1},
  # ipaddr
  {attr_NAS_IP_Address(), {1, 2, 3, 4}},
  {attr_NAS_IP_Address(), 0x12345678},
  # ipv6addr
  {attr_Login_IPV6_Host(), {2003, 0xEFFF, 0, 0, 0, 0, 0, 4}},
  # VSA
  {{attr_Vendor_Specific(), 9},
   [
     {"Cisco-Disconnect-Cause", 10},
     {195, "Unknown"}
   ]},
  # empty VSA?
  {{attr_Vendor_Specific(), "Microsoft"}, []},
  # some unknown attribute
  {255, "123456"}
]

# for request packets, authenticator will generate with random bytes
p = %Radius.Packet{code: "Access-Request", id: 12, secret: secret, attrs: attrs}
# will return an iolist
%{raw: data} = Radius.Packet.encode_request(p)
Logger.debug("data=#{inspect(data)}")

p = Radius.Packet.decode(:erlang.iolist_to_binary(data), secret)
Logger.debug(inspect(p, pretty: true))

# for response packets, provide request.auth to generate new HMAC-hash with it.
p2 = %Radius.Packet{code: "Access-Accept", id: 12, secret: secret, attrs: p.attrs}
%{raw: data} = Radius.Packet.encode_reply(p2, p.auth)
Logger.debug("data=#{inspect(data)}")
# password decoding SHOULD FAIL here, guess why?
p = Radius.Packet.decode(:erlang.iolist_to_binary(data), p2.secret)
Logger.debug(inspect(p, pretty: true))

# wrapper of gen_udp
{:ok, sk} = Radius.listen(1812)

loop = fn loop ->
  # secret can be a string or a function returning a string
  # {:ok,host,p} = Radius.recv sk,"123"
  {:ok, host, p} = Radius.recv(sk, fn _host -> secret end)

  IO.puts("From #{inspect(host)} : \n#{inspect(p, pretty: true)}")

  resp = %Radius.Packet{code: "Access-Reject", id: p.id, secret: p.secret}
  Radius.send_reply(sk, host, resp, p.auth)

  loop.(loop)
end

loop.(loop)
