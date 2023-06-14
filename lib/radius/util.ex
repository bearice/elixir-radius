defmodule Radius.Util do
  @moduledoc false
  require Logger
  import Bitwise

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
    acc |> Enum.reverse() |> IO.iodata_to_binary()
  end

  @block_binary_size 16
  @block_size @block_binary_size * 8
  defp hash_xor(<<block::binary-size(@block_binary_size), rest::binary>>, hash, secret, acc, opts) do
    hash = :crypto.hash(:md5, secret <> hash)
    xor_block = binary_xor(block, hash)
    next = if(opts |> Keyword.get(:reverse, false), do: block, else: xor_block)
    hash_xor(rest, next, secret, [xor_block | acc])
  end

  defp binary_xor(<<x::size(@block_size)>>, <<y::size(@block_size)>>) do
    z = bxor(x, y)
    <<z::size(@block_size)>>
  end

  defp pad_to_16(bin) do
    remainder = Integer.mod(byte_size(bin), 16)

    if remainder == 0 do
      bin
    else
      padding = 16 - remainder
      <<bin::binary, 0::size(padding * 8)>>
    end
  end
end
