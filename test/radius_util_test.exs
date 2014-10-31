defmodule RadiusUtilTest do
  use ExUnit.Case

  @a <<131, 203, 230, 68, 225, 38, 170, 174, 240, 200, 112, 101, 138, 46, 93, 66>>
  @e <<47, 30, 188, 38, 120, 163, 223, 41, 29, 48, 100, 113, 255, 68, 152, 156>>
  @s "112233"
  @p "1234"

  test "RFC2865 encrypt" do
    assert RadiusUtil.encrypt_rfc2865(@p,@s,@a) == @e
  end
  test "RFC2865 decrypt" do
    assert RadiusUtil.decrypt_rfc2865(@e,@s,@a) == @p
  end
  test "RFC2865 utf8" do
    p = "测试1234测试1234测试1234"
    e = RadiusUtil.encrypt_rfc2865(p,@s,@a)
    assert RadiusUtil.decrypt_rfc2865(e,@s,@a) == p
  end
  test "RFC2865 empty_string" do
    p = ""
    e = RadiusUtil.encrypt_rfc2865(p,@s,@a)
    assert RadiusUtil.decrypt_rfc2865(e,@s,@a) == p
  end
  test "RFC2868" do
    p = "测试1234测试1234测试1234"
    e = RadiusUtil.encrypt_rfc2868(p,@s,@a)
    assert RadiusUtil.decrypt_rfc2868(e,@s,@a) == p
  end
end
