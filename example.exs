require Logger
#RadiusApp.start :normal,[]

#IO.puts inspect RadiusDict.Vendor.by_name("Cisco")
#IO.puts inspect RadiusDict.Attribute.by_name("Service-Type")
#IO.puts inspect RadiusDict.Value.by_name("Service-Type","Login-User")
#IO.puts inspect RadiusDict.Value.by_value(6,11)
#IO.puts inspect RadiusDict.Value.by_name("Cisco","Cisco-Disconnect-Cause","Unknown")
#IO.puts inspect RadiusDict.Value.by_value(9,195,11)
#IO.puts inspect RadiusDict.Value.by_value(9,1950,11)

secret = "112233"

attrs = [
  {"User-Password","1234"},
  #tagged attribute (rfc2868)
  {"Tunnel-Type","PPTP"},
  #equals
  {"Tunnel-Type",{0,"PPTP"}},
  {"Tunnel-Type",{10,"PPTP"}},
  {"Service-Type","Login-User"},
  #tag & value can be integer
  {6,1},
  #ipaddr
  {"NAS-IP-Address",{1,2,3,4}},
  {"NAS-IP-Address",0x12345678},
  #ipv6addr
  {"Login-IPv6-Host",{2003,0xefff,0,0,0,0,0,4}},
  #VSA
  {{"Vendor-Specific",9},[
    {"Cisco-Disconnect-Cause",10},
    {195,"Unknown"}
  ]},
  #empty VSA?
  {{"Vendor-Specific",311},[]},
  #some unknown attribute
  {255,"123456"}
]

#for request packets, leave auth=nil will generate with random bytes
p = %Radius.Packet{code: "Access-Request", id: 12, auth: nil, secret: secret, attrs: attrs}
#will return an iolist
data =  Radius.Packet.encode p
Logger.debug "data=#{inspect data}"

p = Radius.Packet.decode :erlang.iolist_to_binary(data),secret
Logger.debug inspect p, pretty: true

#for response packets, set auth=request.auth for password decoding
p = %Radius.Packet{code: "Access-Accept", id: 12, auth: p.auth, secret: secret, attrs: p.attrs}
data =  Radius.Packet.encode p
Logger.debug "data=#{inspect data}"
#password decoding SHOULD FAIL here, guess why?
p = Radius.Packet.decode :erlang.iolist_to_binary(data),p.secret
Logger.debug inspect p, pretty: true

#wrapper of gen_udp
{:ok,sk} = Radius.listen 1812

loop = fn(loop)->
  #secret can be a string or a function returning a string
  #{:ok,host,p} = Radius.recvfrom sk,"123"
  {:ok,host,p} = Radius.recvfrom sk,fn(_host) -> secret end

  IO.puts "From #{inspect host} : \n#{inspect p, pretty: true}"

  resp = %Radius.Packet{code: "Access-Reject", id: p.id, auth: p.auth, secret: p.secret}
  Radius.sendto sk,host,resp

  loop.(loop)
end
loop.(loop)
