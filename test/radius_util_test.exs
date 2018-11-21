defmodule Radius.UtilTest do
  use ExUnit.Case

  @a <<131, 203, 230, 68, 225, 38, 170, 174, 240, 200, 112, 101, 138, 46, 93, 66>>
  @e <<47, 30, 188, 38, 120, 163, 223, 41, 29, 48, 100, 113, 255, 68, 152, 156>>
  @s "112233"
  @p "1234"

  @a_long <<112, 201, 55, 232, 16, 34, 158, 42, 134, 188, 54, 96, 180, 224, 125, 13>>
  @e_long <<3, 1, 53, 143, 84, 247, 176, 236, 161, 76, 181, 246, 222, 25, 58, 108, 86, 46, 119, 108, 134, 209, 142, 31, 93, 83, 184, 136, 162, 52, 164, 111>>
  @s_long "abcd"
  @p_long "12345678901234567890"

  test "RFC2865 encrypt" do
    assert Radius.Util.encrypt_rfc2865(@p,@s,@a) == @e
  end
  test "RFC2865 encrypt (long)" do
    assert Radius.Util.encrypt_rfc2865(@p_long,@s_long,@a_long) == @e_long
  end
  test "RFC2865 decrypt" do
    assert Radius.Util.decrypt_rfc2865(@e,@s,@a) == @p
  end
  test "RFC2865 decrypt (long)" do
    assert Radius.Util.decrypt_rfc2865(@e_long,@s_long,@a_long) == @p_long
  end
  test "RFC2865 utf8" do
    p = "测试1234测试1234测试1234"
    e = Radius.Util.encrypt_rfc2865(p,@s,@a)
    assert Radius.Util.decrypt_rfc2865(e,@s,@a) == p
  end
  test "RFC2865 empty_string" do
    p = ""
    e = Radius.Util.encrypt_rfc2865(p,@s,@a)
    assert Radius.Util.decrypt_rfc2865(e,@s,@a) == p
  end
  test "RFC2868" do
    p = "测试1234测试1234测试1234"
    e = Radius.Util.encrypt_rfc2868(p,@s,@a)
    assert Radius.Util.decrypt_rfc2868(e,@s,@a) == p
  end
end
