defmodule Radius.UtilTest do
  use ExUnit.Case

  @a <<131,203,230,68,225,38,170,174,240,200,112,101,138,46,93,66>>
  @e <<47,30,188,38,120,163,223,41,29,48,100,113,255,68,152,156>>
  @s "112233"
  @p "1234"

  @a_long <<112,201,55,232,16,34,158,42,134,188,54,96,180,224,125,13>>
  @e_long <<3,1,53,143,84,247,176,236,161,76,181,246,222,25,58,
    108,86,46,119,108,134,209,142,31,93,83,184,136,162,52,164,111>>
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

  @secret "mykey"
  @sample_packet <<1, 118, 0, 173, 55, 91, 232, 245, 150, 233, 11, 207, 252,
    94, 50, 146, 157, 20, 39, 91, 4, 6, 10, 62, 1, 238, 5, 6, 0, 0, 195, 81, 61,
    6, 0, 0, 0, 15, 1, 31, 104, 111, 115, 116, 47, 100, 114, 115, 119, 105, 110,
    55, 116, 114, 97, 99, 121, 112, 46, 100, 114, 115, 108, 46, 99, 111, 46, 117,
    107, 30, 19, 48, 48, 45, 49, 50, 45, 48, 48, 45, 69, 51, 45, 52, 49, 45, 67,
    49, 31, 19, 66, 52, 45, 57, 57, 45, 66, 65, 45, 70, 50, 45, 56, 65, 45, 68,
    54, 6, 6, 0, 0, 0, 2, 12, 6, 0, 0, 5, 220, 79, 36, 2, 0, 0, 34, 1, 104, 111,
    115, 116, 47, 100, 114, 115, 119, 105, 110, 55, 116, 114, 97, 99, 121, 112,
    46, 100, 114, 115, 108, 46, 99, 111, 46, 117, 107, 80, 18, 201, 62, 246, 40,
    105, 10, 87, 139, 49, 112, 155, 11, 188, 202, 222, 65>>

  test "Message-Authenticator" do
    packet = Radius.Packet.decode(@sample_packet, @secret)
    raw = packet |> Radius.Packet.encode(raw: true) |> IO.iodata_to_binary()
    assert raw == @sample_packet

    attrs =
      packet.attrs
      |> Enum.filter(fn {k, _} -> k != "Message-Authenticator" end)

    signed =
      %{packet | attrs: attrs}
      |> Radius.Packet.encode(sign: true, raw: true)
      |> IO.iodata_to_binary()
      |> Radius.Packet.decode(@secret)

    sig1 = packet |> Radius.Packet.get_attr("Message-Authenticator")
    sig2 = signed |> Radius.Packet.get_attr("Message-Authenticator")

    assert sig1 == sig2

    raw = signed |> Radius.Packet.encode(raw: true) |> IO.iodata_to_binary

    assert raw == @sample_packet

    assert Radius.Packet.verify(packet)
  end
end
