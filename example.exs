require Logger
# RadiusApp.start :normal,[]

# IO.puts inspect RadiusDict.Vendor.by_name("Cisco")
# IO.puts inspect RadiusDict.Attribute.by_name("Service-Type")
# IO.puts inspect RadiusDict.Value.by_name("Service-Type","Login-User")
# IO.puts inspect RadiusDict.Value.by_value(6,11)
# IO.puts inspect RadiusDict.Value.by_name("Cisco","Cisco-Disconnect-Cause","Unknown")
# IO.puts inspect RadiusDict.Value.by_value(9,195,11)
# IO.puts inspect RadiusDict.Value.by_value(9,1950,11)

secret = "112233"

attrs = [
  {"User-Password", "1234"},
  # tagged attribute (rfc2868)
  {"Tunnel-Type", "PPTP"},
  # equals
  {"Tunnel-Type", {0, "PPTP"}},
  {"Tunnel-Type", {10, "PPTP"}},
  {"Service-Type", "Login-User"},
  # tag & value can be integer
  {6, 1},
  # ipaddr
  {"NAS-IP-Address", {1, 2, 3, 4}},
  {"NAS-IP-Address", 0x12345678},
  # ipv6addr
  {"Login-IPv6-Host", {2003, 0xEFFF, 0, 0, 0, 0, 0, 4}},
  # VSA
  {{"Vendor-Specific", 9},
   [
     {"Cisco-Disconnect-Cause", 10},
     {195, "Unknown"}
   ]},
  # empty VSA?
  {{"Vendor-Specific", "Microsoft"}, []},
  # some unknown attribute
  {255, "123456"}
]

# for request packets, authenticator will generate with random bytes
p = %Radius.Packet{code: "Access-Request", id: 12, secret: secret, attrs: attrs}
# will return an iolist
%{raw: data} = Radius.Packet.encode_request(p)
Logger.debug("data=#{inspect(packet.raw)}")

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

  resp = %Radius.Packet{code: "Access-Reject", id: p.id, auth: p.auth, secret: p.secret}
  Radius.send(sk, host, resp)

  loop.(loop)
end

loop.(loop)
