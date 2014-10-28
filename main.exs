RadiusDict.start_link("dict/dictionary")
IO.puts inspect RadiusDict.Value.by_name("Service-Type","Login-User")
IO.puts inspect RadiusDict.Value.by_value(6,11)
IO.puts inspect RadiusDict.Value.by_name("Cisco","Cisco-Disconnect-Cause","Unknown")
IO.puts inspect RadiusDict.Value.by_value(9,195,11)
#IO.puts inspect RadiusDict.Value.by_value(9,1950,11)

{:ok,sk} = Radius.listen 1812
p = Radius.recv sk,"123"
IO.puts inspect p
