defmodule RadiusUtil do
  use Bitwise
  def encrypt_rfc2865(passwd,secret,auth) do
    passwd |> String.ljust(16,0) |> hash_xor(auth,secret,[])
  end

  def decrypt_rfc2865(passwd,secret,auth) do
    passwd |> hash_xor(auth,secret,[]) |> String.rstrip 0
  end

  def encrypt_rfc2868(passwd,secret,auth) do
    salt = :crypto.rand_bytes 2
    passwd |> String.ljust(16,0) |> hash_xor(auth<>salt,secret,[])
  end
  def decrypt_rfc2868(<<salt::binary-size(2),passwd::binary>>,secret,auth) do
    passwd |> hash_xor(auth<>salt,secret,[]) |> String.rstrip 0
  end

  defp hash_xor(<<>>,_,_,acc) do
    acc |> Enum.reverse |> :erlang.iolist_to_binary
  end
  defp hash_xor(<<txt::binary-size(16),rest::binary>>,hash,secret,acc) do
    hash = :crypto.hash(:md5, secret <> hash)
    txt = binary_xor txt,hash
    hash_xor(rest,hash,secret,[txt|acc])
  end

  def binary_xor(x,y) when byte_size(x) == byte_size(y) do
    s = byte_size(x) * 8
    <<x::size(s)>>=x
    <<y::size(s)>>=y
    z=x^^^y
    <<z::size(s)>>
  end

end
