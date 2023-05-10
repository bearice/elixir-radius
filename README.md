elixir-radius
=============

[![CI](https://github.com/bearice/elixir-radius/actions/workflows/elixir.yml/badge.svg)](https://github.com/bearice/elixir-radius/actions/workflows/elixir.yml)

[![Hex.pm version](https://img.shields.io/hexpm/v/elixir_radius.svg?style=flat)](https://hex.pm/packages/elixir_radius)

RADIUS protocol encoding and decoding

example
-------
```Elixir
#wrapper of gen_udp
{:ok,sk} = Radius.listen 1812

loop = fn(loop)->
  #secret can be a string or a function returning a string
  #{:ok,host,p} = Radius.recv sk,"123"
  {:ok,host,p} = Radius.recv sk,fn(_host) -> secret end

  IO.puts "From #{inspect host} : \n#{inspect p, pretty: true}"

  resp = %Radius.Packet{code: "Access-Reject", id: p.id, secret: p.secret}
  Radius.send_reply(sk, host, resp, p.auth)

  loop.(loop)
end
loop.(loop)
```
