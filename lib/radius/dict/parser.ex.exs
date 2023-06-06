defmodule Radius.Dict.Parser do
  def parse(binary) do
    {:ok, _, "", ctx, _, _} =
      parse_bin(binary, context: [attributes: [], values: [], prepend_key: []])

    ctx
  end

  def parse_index(binary) do
    includes =
      binary
      |> String.split("\n")
      |> Enum.filter(&String.starts_with?(&1, "$INCLUDE dictionary."))
      |> Enum.map(fn include ->
        String.replace_leading(include, "$INCLUDE dictionary.", "")
      end)

    parsed = parse(binary)

    {includes, Map.get(parsed, :attributes), Map.get(parsed, :values)}
  end

  # parsec:Radius.Dict.Parser
  import NimbleParsec

  separator = ascii_string([?\s, ?\t], min: 1)
  name = ascii_string([not: ?\t, not: ?\n, not: ?\s], min: 1)

  vendor = string("VENDOR") |> replace(:vendor)
  attribute = string("ATTRIBUTE") |> replace(:attribute)
  value = string("VALUE") |> replace(:value)

  hex_identifier =
    ignore(string("0x"))
    |> choice([
      ascii_string([?a..?f, ?A..?F, ?0..?9], 8),
      ascii_string([?a..?f, ?A..?F, ?0..?9], 4),
      ascii_string([?a..?f, ?A..?F, ?0..?9], 3),
      ascii_string([?a..?f, ?A..?F, ?0..?9], 2),
      ascii_string([?a..?f, ?A..?F, ?0..?9], 1)
    ])
    |> reduce(:hex_to_integer)

  identifier =
    choice([
      hex_identifier,
      integer(10),
      integer(5),
      integer(4),
      integer(3),
      integer(2),
      integer(1)
    ])

  attribute_type =
    choice([
      string("string") |> replace(:string),
      string("octets") |> replace(:octets),
      string("ipaddr") |> replace(:ipaddr),
      string("integer") |> replace(:integer),
      string("signed") |> replace(:signed),
      string("date") |> replace(:date),
      string("ifid") |> replace(:ifid),
      string("ipv6addr") |> replace(:ipv6addr),
      string("ipv6prefix") |> replace(:ipv6prefix),
      string("ether") |> replace(:ether),
      string("abinary") |> replace(:abinary),
      string("byte") |> replace(:byte),
      string("short") |> replace(:short)
    ])

  comment =
    optional(ignore(separator))
    |> string("#")
    |> optional(ascii_string([not: ?\n], min: 1))

  include_line =
    string("$INCLUDE")
    |> ignore(separator)
    |> ignore(string("dictionary."))
    |> concat(name)

  begin_line =
    string("BEGIN-VENDOR")
    |> ignore(separator)
    |> concat(name)

  end_line =
    string("END-VENDOR")
    |> ignore(separator)
    |> concat(name)

  attribute_line =
    attribute
    |> ignore(separator)
    |> concat(name)
    |> ignore(separator)
    |> concat(identifier)
    |> ignore(separator)
    |> concat(attribute_type)
    |> optional(
      ignore(separator)
      |> optional(string("has_tag") |> replace(true) |> unwrap_and_tag(:has_tag))
      |> optional(ignore(string(",")))
      |> optional(ignore(string("encrypt=")) |> integer(1) |> unwrap_and_tag(:encrypt))
      |> tag(:opts)
    )
    |> post_traverse(:store_attribute)

  value_line =
    value
    |> ignore(separator)
    |> concat(name)
    |> ignore(separator)
    |> concat(name)
    |> ignore(separator)
    |> concat(identifier)
    |> post_traverse(:store_value)

  vendor_line =
    vendor
    |> ignore(separator)
    |> concat(name)
    |> ignore(separator)
    |> concat(identifier)
    |> optional(
      ignore(separator)
      |> ignore(string("format="))
      |> integer(1)
      |> ignore(string(","))
      |> integer(1)
      |> optional(ignore(string(",c")))
      |> tag(:format)
    )
    |> post_traverse(:store_vendor)

  vendor_chapter =
    ignore(begin_line)
    |> post_traverse({:prepend_store_key, [[:vendor]]})
    |> repeat(
      choice([
        ignore(string("\n")),
        attribute_line,
        value_line,
        ignore(comment)
      ])
    )
    |> ignore(end_line)
    |> post_traverse({:prepend_store_key, [[]]})

  defparsecp(
    :parse_bin,
    choice([
      ignore(string("\n")),
      attribute_line,
      value_line,
      vendor_line,
      vendor_chapter,
      ignore(include_line),
      ignore(comment)
    ])
    |> repeat()
  )

  # parsec:Radius.Dict.Parser

  defp prepend_store_key(_rest, _, context, _line, _offset, key) do
    {[], Map.put(context, :prepend_key, key)}
  end

  defp store_vendor(_rest, vendor, context, _line, _offset) do
    [:vendor, name, id | opts] = Enum.reverse(vendor)
    {[], Map.put(context, :vendor, %{id: id, name: name, opts: opts, attributes: [], values: []})}
  end

  defp store_attribute(_rest, attr, context, _line, _offset) do
    [:attribute, name, id, type | rest] = Enum.reverse(attr)
    opts = Keyword.get(rest, :opts, [])
    attribute = %{name: name, id: id, type: type, opts: opts}

    {[],
     update_in(context, context.prepend_key ++ [:attributes], fn attrs -> [attribute | attrs] end)}
  end

  defp store_value(_rest, [value, name, attr_name, :value], context, _line, _offset) do
    value = %{attr: attr_name, value: value, name: name}

    {[], update_in(context, context.prepend_key ++ [:values], fn values -> [value | values] end)}
  end

  defp hex_to_integer([hex]) do
    String.to_integer(hex, 16)
  end
end
