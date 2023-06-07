elixir-radius
=============

[![CI](https://github.com/bearice/elixir-radius/actions/workflows/elixir.yml/badge.svg)](https://github.com/bearice/elixir-radius/actions/workflows/elixir.yml) [![Hex.pm version](https://img.shields.io/hexpm/v/elixir_radius.svg?style=flat)](https://hex.pm/packages/elixir_radius)

RADIUS protocol encoding and decoding

Example
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

Dictionary configuration
--------------------


Vendor specific dictionaries are compiled into a specific vendor module. Generic attributes and values
are compiled into `Radius.Dict`. If you add the "cisco" dictionary you will get the module `Radius.Dict.VendorCisco`.

```Elixir
config :elixir_radius,
  included_dictionaries: ["rfc2865", "rfc2868", "rfc2869", "cisco"]
```

NOTE: By default, this library will compile all known vendors, which is quite slow, but had maxium compatibility with old versions. If you dont need them, please use above config to select what to be compiled.

You can also add your own dictionaries by providing the paths to `:elixir_radius` in `:extra_dictionaries`

```Elixir
config :elixir_radius,
  extra_dictionaries: ["path_to_your_dictionary"]
```

Macros
------

`Radius.Dict` exposes a set of macro's so you can construct AVPs and let the compiler confirm the
attributes and save time during runtime.
