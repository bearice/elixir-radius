require Logger
RadiusDict.start_link("dict/dictionary")
IO.puts inspect RadiusDict.Vendor.by_name("Cisco")
IO.puts inspect RadiusDict.Attribute.by_name("Service-Type")
IO.puts inspect RadiusDict.Value.by_name("Service-Type","Login-User")
IO.puts inspect RadiusDict.Value.by_value(6,11)
IO.puts inspect RadiusDict.Value.by_name("Cisco","Cisco-Disconnect-Cause","Unknown")
IO.puts inspect RadiusDict.Value.by_value(9,195,11)
#IO.puts inspect RadiusDict.Value.by_value(9,1950,11)

attrs = [
  #test name resolve
  {"Service-Type","Login-User"},
  #test id resolve
  {6,1},
  #test fot has_tag
  {"Tunnel-Type","PPTP"},
  {"NAS-IP-Address",{1,2,3,4}},
  {"NAS-IP-Address",0x12345678},
  {"Login-IPv6-Host",{2003,0xefff,0,0,0,0,0,4}},
  #test VSA
  {{"Vendor-Specific",9},[
    {"Cisco-Disconnect-Cause",10},
    {195,100,"Unknown"}
  ]},
  #empty VSA?
  {{"Vendor-Specific",311},[]}
]

p = %Radius.Packet{code: "Access-Reject", id: 12, auth: :crypto.hash(:md5,"asd"), secret: "112233", attrs: attrs}

data =  Radius.Packet.encode p
Logger.debug "data=#{inspect data}"
IO.puts inspect (Radius.Packet.decode :erlang.iolist_to_binary(data),p.secret), pretty: true

{:ok,sk} = Radius.listen 1812
{:ok,host,p} = Radius.recvfrom sk,"123"
IO.puts "From #{inspect host} : \n#{inspect p, pretty: true}"
resp = %Radius.Packet{code: "Access-Reject", id: p.id, auth: p.auth, secret: p.secret}
Radius.sendto sk,host,resp
