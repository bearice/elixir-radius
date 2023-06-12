defmodule Radius.PacketTest do
  use ExUnit.Case, async: true
  use Radius.Dict

  @secret "mykey"
  @sample_macro_req %Radius.Packet{
    code: "Access-Request",
    id: 118,
    length: 173,
    auth: <<55, 91, 232, 245, 150, 233, 11, 207, 252, 94, 50, 146, 157, 20, 39, 91>>,
    attrs: [
      {attr_NAS_IP_Address(), {10, 62, 1, 238}},
      {attr_NAS_Port(), 50001},
      {attr_NAS_Port_Type(), val_NAS_Port_Type_Ethernet()},
      {attr_User_Name(), "host/drswin7tracyp.drsl.co.uk"},
      {attr_Called_Station_Id(), "00-12-00-E3-41-C1"},
      {attr_Calling_Station_Id(), "B4-99-BA-F2-8A-D6"},
      {attr_Service_Type(), val_Service_Type_Framed_User()},
      {attr_Framed_MTU(), 1500},
      {attr_EAP_Message(),
       <<2, 0, 0, 34, 1, 104, 111, 115, 116, 47, 100, 114, 115, 119, 105, 110, 55, 116, 114, 97,
         99, 121, 112, 46, 100, 114, 115, 108, 46, 99, 111, 46, 117, 107>>},
      {attr_Message_Authenticator(),
       <<201, 62, 246, 40, 105, 10, 87, 139, 49, 112, 155, 11, 188, 202, 222, 65>>}
    ],
    raw: nil,
    secret: "mykey"
  }
  @sample_req %Radius.Packet{
    code: "Access-Request",
    id: 118,
    length: 173,
    auth: <<55, 91, 232, 245, 150, 233, 11, 207, 252, 94, 50, 146, 157, 20, 39, 91>>,
    attrs: [
      {"NAS-IP-Address", {10, 62, 1, 238}},
      {"NAS-Port", 50001},
      {"NAS-Port-Type", "Ethernet"},
      {"User-Name", "host/drswin7tracyp.drsl.co.uk"},
      {"Called-Station-Id", "00-12-00-E3-41-C1"},
      {"Calling-Station-Id", "B4-99-BA-F2-8A-D6"},
      {"Service-Type", "Framed-User"},
      {"Framed-MTU", 1500},
      {"EAP-Message",
       <<2, 0, 0, 34, 1, 104, 111, 115, 116, 47, 100, 114, 115, 119, 105, 110, 55, 116, 114, 97,
         99, 121, 112, 46, 100, 114, 115, 108, 46, 99, 111, 46, 117, 107>>},
      {"Message-Authenticator",
       <<201, 62, 246, 40, 105, 10, 87, 139, 49, 112, 155, 11, 188, 202, 222, 65>>}
    ],
    raw: nil,
    secret: "mykey"
  }
  @sample_binary_req <<1, 118, 0, 173, 55, 91, 232, 245, 150, 233, 11, 207, 252, 94, 50, 146, 157,
                       20, 39, 91, 4, 6, 10, 62, 1, 238, 5, 6, 0, 0, 195, 81, 61, 6, 0, 0, 0, 15,
                       1, 31, 104, 111, 115, 116, 47, 100, 114, 115, 119, 105, 110, 55, 116, 114,
                       97, 99, 121, 112, 46, 100, 114, 115, 108, 46, 99, 111, 46, 117, 107, 30,
                       19, 48, 48, 45, 49, 50, 45, 48, 48, 45, 69, 51, 45, 52, 49, 45, 67, 49, 31,
                       19, 66, 52, 45, 57, 57, 45, 66, 65, 45, 70, 50, 45, 56, 65, 45, 68, 54, 6,
                       6, 0, 0, 0, 2, 12, 6, 0, 0, 5, 220, 79, 36, 2, 0, 0, 34, 1, 104, 111, 115,
                       116, 47, 100, 114, 115, 119, 105, 110, 55, 116, 114, 97, 99, 121, 112, 46,
                       100, 114, 115, 108, 46, 99, 111, 46, 117, 107, 80, 18, 201, 62, 246, 40,
                       105, 10, 87, 139, 49, 112, 155, 11, 188, 202, 222, 65>>
  @sample_rep %Radius.Packet{
    code: "Access-Accept",
    id: 118,
    length: 155,
    auth: <<25, 149, 189, 198, 178, 14, 197, 28, 131, 240, 157, 146, 150, 38, 53, 105>>,
    attrs: [
      {"NAS-IP-Address", {10, 62, 1, 238}},
      {"NAS-Port", 50001},
      {"NAS-Port-Type", "Ethernet"},
      {"User-Name", "host/drswin7tracyp.drsl.co.uk"},
      {"Called-Station-Id", "00-12-00-E3-41-C1"},
      {"Calling-Station-Id", "B4-99-BA-F2-8A-D6"},
      {"Service-Type", "Framed-User"},
      {"Framed-MTU", 1500},
      {"EAP-Message",
       <<2, 0, 0, 34, 1, 104, 111, 115, 116, 47, 100, 114, 115, 119, 105, 110, 55, 116, 114, 97,
         99, 121, 112, 46, 100, 114, 115, 108, 46, 99, 111, 46, 117, 107>>}
    ],
    raw: nil,
    secret: "mykey"
  }
  @sample_binary_rep <<2, 118, 0, 155, 25, 149, 189, 198, 178, 14, 197, 28, 131, 240, 157, 146,
                       150, 38, 53, 105, 4, 6, 10, 62, 1, 238, 5, 6, 0, 0, 195, 81, 61, 6, 0, 0,
                       0, 15, 1, 31, 104, 111, 115, 116, 47, 100, 114, 115, 119, 105, 110, 55,
                       116, 114, 97, 99, 121, 112, 46, 100, 114, 115, 108, 46, 99, 111, 46, 117,
                       107, 30, 19, 48, 48, 45, 49, 50, 45, 48, 48, 45, 69, 51, 45, 52, 49, 45,
                       67, 49, 31, 19, 66, 52, 45, 57, 57, 45, 66, 65, 45, 70, 50, 45, 56, 65, 45,
                       68, 54, 6, 6, 0, 0, 0, 2, 12, 6, 0, 0, 5, 220, 79, 36, 2, 0, 0, 34, 1, 104,
                       111, 115, 116, 47, 100, 114, 115, 119, 105, 110, 55, 116, 114, 97, 99, 121,
                       112, 46, 100, 114, 115, 108, 46, 99, 111, 46, 117, 107>>
  @sample_binary_rep_signed <<2, 118, 0, 173, 132, 213, 98, 44, 33, 151, 126, 7, 160, 110, 91, 18,
                              56, 125, 67, 245, 80, 18, 27, 203, 27, 162, 52, 156, 30, 25, 241,
                              43, 80, 77, 28, 109, 228, 77, 4, 6, 10, 62, 1, 238, 5, 6, 0, 0, 195,
                              81, 61, 6, 0, 0, 0, 15, 1, 31, 104, 111, 115, 116, 47, 100, 114,
                              115, 119, 105, 110, 55, 116, 114, 97, 99, 121, 112, 46, 100, 114,
                              115, 108, 46, 99, 111, 46, 117, 107, 30, 19, 48, 48, 45, 49, 50, 45,
                              48, 48, 45, 69, 51, 45, 52, 49, 45, 67, 49, 31, 19, 66, 52, 45, 57,
                              57, 45, 66, 65, 45, 70, 50, 45, 56, 65, 45, 68, 54, 6, 6, 0, 0, 0,
                              2, 12, 6, 0, 0, 5, 220, 79, 36, 2, 0, 0, 34, 1, 104, 111, 115, 116,
                              47, 100, 114, 115, 119, 105, 110, 55, 116, 114, 97, 99, 121, 112,
                              46, 100, 114, 115, 108, 46, 99, 111, 46, 117, 107>>

  test "decode request" do
    packet = Radius.Packet.decode(@sample_binary_req, @secret)
    assert packet.code == @sample_req.code
    assert packet.id == @sample_req.id
    assert packet.length == @sample_req.length

    assert packet.auth == @sample_req.auth
  end

  test "decode reply" do
    packet = Radius.Packet.decode(@sample_binary_rep, @secret)

    assert {"NAS-Port", 50001} = Enum.find(packet.attrs, fn {k, _v} -> k == "NAS-Port" end)
    assert packet.code == @sample_rep.code
    assert packet.id == @sample_rep.id
    assert packet.length == @sample_rep.length
    assert packet.auth == @sample_rep.auth
  end

  test "decode reply - attributes as integer" do
    packet = Radius.Packet.decode(@sample_binary_rep, @secret, attributes: :integers)

    assert {attr_NAS_Port(), 50001} =
             Enum.find(packet.attrs, fn {k, _v} -> k == attr_NAS_Port() end)

    assert packet.code == @sample_rep.code
    assert packet.id == @sample_rep.id
    assert packet.length == @sample_rep.length
    assert packet.auth == @sample_rep.auth
  end

  test "encode request - deprecated" do
    # cut authenticator as it will be generated on each encoding
    <<before::size(32), _random::size(128), rest::binary>> =
      @sample_req
      |> Map.put(:auth, nil)
      |> Radius.Packet.encode()
      |> IO.iodata_to_binary()

    <<sample_before::size(32), _random::size(128), sample_rest::binary>> = @sample_binary_req
    assert <<before::size(32), rest::binary>> == <<sample_before::size(32), sample_rest::binary>>
  end

  test "encode reply - deprecated" do
    reply =
      @sample_rep
      |> Map.put(:auth, @sample_req.auth)
      |> Radius.Packet.encode()
      |> IO.iodata_to_binary()

    assert reply == @sample_binary_rep
  end

  test "encode request" do
    # cut authenticator as it will be generated on each encoding
    <<before::size(32), _random::size(128), rest::binary>> =
      @sample_req |> Radius.Packet.encode_request() |> Map.get(:raw) |> IO.iodata_to_binary()

    <<sample_before::size(32), _random::size(128), sample_rest::binary>> = @sample_binary_req
    assert <<before::size(32), rest::binary>> == <<sample_before::size(32), sample_rest::binary>>
  end

  test "encode macro request" do
    # cut authenticator as it will be generated on each encoding
    <<before::size(32), _random::size(128), rest::binary>> =
      @sample_macro_req
      |> Radius.Packet.encode_request()
      |> Map.get(:raw)
      |> IO.iodata_to_binary()

    <<sample_before::size(32), _random::size(128), sample_rest::binary>> = @sample_binary_req
    assert <<before::size(32), rest::binary>> == <<sample_before::size(32), sample_rest::binary>>
  end

  test "encode request with vsa" do
    secret = "112233"

    attrs = [
      attr_User_Password("1234"),
      # tagged attribute (rfc2868)
      attr_Tunnel_Type(val_Tunnel_Type_PPTP()),
      # equals
      {attr_Tunnel_Type(), {0, "PPTP"}},
      attr_Tunnel_Type({10, "PPTP"}),
      {attr_Service_Type(), "Login-User"},
      # tag & value can be integer
      {6, 1},
      # ipaddr
      {attr_NAS_IP_Address(), {1, 2, 3, 4}},
      {attr_NAS_IP_Address(), 0x12345678},
      # ipv6addr
      {attr_Login_IPv6_Host(), {2003, 0xEFFF, 0, 0, 0, 0, 0, 4}},
      # VSA
      {{attr_Vendor_Specific(), 9},
       [
         {"Cisco-Disconnect-Cause", 10},
         {195, "Unknown"}
       ]},
      # empty VSA?
      {{attr_Vendor_Specific(), "Microsoft"}, []},
      # some unknown attribute
      {255, "123456"}
    ]

    # for request packets, authenticator will generate with random bytes
    p = %Radius.Packet{code: "Access-Request", id: 12, secret: secret, attrs: attrs}
    # will return an iolist
    data = Radius.Packet.encode_request(p) |> Map.get(:raw) |> IO.iodata_to_binary()

    assert is_binary(data)
  end

  test "encode reply" do
    reply =
      @sample_rep
      |> Radius.Packet.encode_reply(@sample_req.auth)
      |> Map.get(:raw)
      |> IO.iodata_to_binary()

    assert reply == @sample_binary_rep
  end

  test "encode and sign reply" do
    reply =
      @sample_rep
      |> Radius.Packet.encode_reply(@sample_req.auth, sign: true)
      |> Map.get(:raw)
      |> IO.iodata_to_binary()

    assert reply == @sample_binary_rep_signed
  end

  test "verify (message) authenticator signature on request" do
    assert Radius.Packet.verify(@sample_req)
    assert Radius.Packet.verify(%{@sample_req | attrs: []})
    refute Radius.Packet.verify(%{@sample_req | id: 14})
  end

  test "verify message authenticator signature on reply" do
    packet = Radius.Packet.decode(@sample_binary_rep_signed, @secret)
    assert Radius.Packet.verify(packet, @sample_req.auth)
    refute Radius.Packet.verify(packet)
    refute Radius.Packet.verify(%{packet | id: 14}, @sample_req.auth)
    refute Radius.Packet.verify(%{packet | attrs: []}, @sample_req.auth)
  end
end
