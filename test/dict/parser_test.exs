defmodule Radius.Dict.ParserTest do
  use ExUnit.Case, async: true

  import Radius.Dict.Parser, only: [parse: 1]

  describe "vendor parsing" do
    test "can parse vendor" do
      vendor = ~S"""
      VENDOR  VendorTest 823
      """

      assert %{vendor: %{id: 823, name: "VendorTest"}} = parse(vendor)
    end

    test "can parse vendor with format" do
      vendor = ~S"""
      VENDOR  VendorFormatTest 823 format=2,0
      """

      assert %{vendor: %{id: 823, name: "VendorFormatTest", opts: [format: [2, 0]]}} =
               parse(vendor)
    end

    test "can parse vendor with comment" do
      vendor = ~S"""
      VENDOR  VendorComment 823 # we leave comments everywhere in the file
      """

      assert %{vendor: %{id: 823, name: "VendorComment"}} = parse(vendor)
    end
  end

  describe "attribute parsing" do
    test "can parse basic attribute" do
      attribute = ~S"""
      ATTRIBUTE	User-Name				1	string
      """

      assert %{attributes: [%{id: 1, name: "User-Name", opts: [], type: :string}]} =
               parse(attribute)
    end

    test "can parse attribute with hex identifier" do
      attribute = ~S"""
      ATTRIBUTE	USR-Last-Number-Dialed-Out		0x0066	string
      """

      assert %{
               attributes: [
                 %{id: 102, name: "USR-Last-Number-Dialed-Out", opts: [], type: :string}
               ]
             } = parse(attribute)
    end

    test "can parse attribute with encrypt option" do
      attribute = ~S"""
      ATTRIBUTE	User-Password				2	string encrypt=1
      """

      assert %{attributes: [%{id: 2, name: "User-Password", opts: [encrypt: 1], type: :string}]} =
               parse(attribute)
    end

    test "can parse attribute with tag" do
      attribute = ~S"""
      ATTRIBUTE	Tunnel-Server-Endpoint			67	string	has_tag
      """

      assert %{
               attributes: [
                 %{id: 67, name: "Tunnel-Server-Endpoint", opts: [has_tag: true], type: :string}
               ]
             } = parse(attribute)
    end

    test "can parse attribute with encrypt and tag option" do
      attribute = ~S"""
      ATTRIBUTE	Tunnel-Password				69	string	has_tag,encrypt=2
      """

      assert %{attributes: [%{id: 69, name: "Tunnel-Password", opts: parsed_opts, type: :string}]} =
               parse(attribute)

      assert 2 = Keyword.get(parsed_opts, :encrypt)
      assert Keyword.get(parsed_opts, :has_tag)
    end
  end
end
