defmodule Radius.Util do
  require Logger

  use Bitwise

  def encrypt_rfc2865(passwd, secret, auth) do
    passwd
    |> pad_to_16()
    |> hash_xor(auth, secret, [])
  end

  def decrypt_rfc2865(passwd, secret, auth) do
    passwd
    |> hash_xor(auth, secret, [], reverse: true)
    |> String.trim_trailing("\0")
  end

  def encrypt_rfc2868(passwd, secret, auth) do
    salt = :crypto.strong_rand_bytes(2)
    encrypted =
      passwd
      |> pad_to_16()
      |> hash_xor(auth <> salt, secret, [])
    salt <> encrypted
  end

  def decrypt_rfc2868(<<salt::binary-size(2), passwd::binary>>, secret, auth) do
    passwd
    |> hash_xor(auth <> salt, secret, [], reverse: true)
    |> String.trim_trailing("\0")
  end

  defp hash_xor(input, hash, secret, acc, opts \\ [])
  defp hash_xor(<<>>, _, _, acc, _) do
    acc |> Enum.reverse() |> :erlang.iolist_to_binary()
  end
  defp hash_xor(<<block::binary-size(16), rest::binary>>, hash, secret, acc, opts) do
    hash = :crypto.hash(:md5, secret <> hash)
    xor_block = binary_xor(block, hash)
    next = if(opts |> Keyword.get(:reverse, false), do: block, else: xor_block)
    hash_xor(rest, next, secret, [xor_block | acc])
  end

  def binary_xor(x, y) when byte_size(x) == byte_size(y) do
    s = byte_size(x) * 8
    <<x::size(s)>> = x
    <<y::size(s)>> = y
    z = x ^^^ y
    <<z::size(s)>>
  end

  def pad_to_16(bin) do
    pad_to_16(bin, [])
    |> Enum.reverse
    |> :erlang.iolist_to_binary()
  end

  def pad_to_16(bin, acc) when byte_size(bin) == 16, do: [bin | acc]
  def pad_to_16(bin, acc) when byte_size(bin) < 16 do
    bin = <<bin::binary,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0>>
    <<chunk::binary-size(16), _::binary>> = bin
    [chunk | acc]
  end
  def pad_to_16(<<chunk::binary-size(16), rest::binary>>, acc),
    do: pad_to_16(rest, [chunk | acc])
end
