defmodule Radius.Dict do
  @moduledoc """
  Parses dictionaries and generates lookup functions and helper macro's.

  The helper macro's give the benefit of compile time checks and faster encoding without losing
  readability.
  """
  require Radius.Dict.Helpers
  alias Radius.Dict.EntryNotFoundError
  alias Radius.Dict.Helpers
  alias Radius.Dict.Parser

  defmacro __using__(_) do
    quote do
      require Radius.Dict
      import Radius.Dict
    end
  end

  extra_dictionaries = Application.compile_env(:elixir_radius, :extra_dictionaries, [])

  {includes, generic_attributes, generic_values} =
    Path.join(["dicts", "dictionary"])
    |> File.read!()
    |> Parser.parse_index()

  filtered_includes =
    if config_includes = Application.compile_env(:elixir_radius, :included_dictionaries) do
      Enum.filter(includes, &(&1 in config_includes))
    else
      includes
    end

  dict_files =
    Enum.map(filtered_includes, fn dict -> Path.join(["dicts", "dictionary.#{dict}"]) end)

  {vendors, attributes, values} =
    Enum.reduce(
      dict_files ++ extra_dictionaries,
      {[], generic_attributes, generic_values},
      fn dict_file, {acc_vendors, acc_attributes, acc_values} ->
        dict =
          dict_file
          |> File.read!()
          |> Parser.parse()

        {acc_attributes, rest} =
          case Map.pop(dict, :attributes) do
            {[], rest} -> {acc_attributes, rest}
            {attributes, rest} -> {attributes ++ acc_attributes, rest}
          end

        {acc_values, rest} =
          case Map.pop(rest, :values) do
            {[], rest} -> {acc_values, rest}
            {values, rest} -> {values ++ acc_values, rest}
          end

        acc_vendors =
          if vendor = Map.get(rest, :vendor) do
            [vendor | acc_vendors]
          else
            acc_vendors
          end

        {acc_vendors, acc_attributes, acc_values}
      end
    )

  Helpers.define_attribute_doc_helpers()

  for attribute <- attributes do
    Helpers.define_attribute_functions(attribute)
  end

  Helpers.define_value_doc_helpers()

  for val <- values do
    Helpers.define_value_functions(val)
  end

  @doc """
  Get vendor struct based on vendor id
  """
  @doc group: :lookup
  def vendor_by_id(attr_id)

  @doc """
  Get vendor struct based on vendor name
  """
  @doc group: :lookup
  def vendor_by_name(attr_name)

  for vendor <- vendors do
    mod = Module.concat(__MODULE__, Helpers.safe_name("Vendor#{vendor.name}"))
    [tl, ll] = Keyword.get(vendor.opts, :format) || [1, 1]
    vendor_data = %{id: vendor.id, name: vendor.name, format: {tl, ll}, module: mod}
    def vendor_by_id(unquote(vendor.id)), do: unquote(Macro.escape(vendor_data))
    def vendor_by_name(unquote(vendor.name)), do: unquote(Macro.escape(vendor_data))

    attribute_funs =
      for attribute <- vendor.attributes do
        quote do
          unquote(Helpers.generate_attribute_functions(Macro.escape(attribute)))
        end
      end

    elixir_compiler_limit = 1024

    value_funs =
      if Enum.count(vendor.attributes ++ vendor.values) < elixir_compiler_limit do
        for val <- vendor.values do
          quote do
            unquote(Helpers.generate_value_functions(Macro.escape(val)))
          end
        end
      else
        for {attr, vals} <- Enum.group_by(vendor.values, & &1.attr) do
          val_fun_name = Helpers.safe_name("val_#{attr}")

          quote location: :keep do
            defmacro unquote(val_fun_name)(val_name),
              do:
                Enum.find_value(
                  unquote(Macro.escape(vals)),
                  &(&1.name == val_name && &1.value)
                )

            def value_by_value(unquote(attr), val_value),
              do:
                Enum.find(
                  unquote(Macro.escape(vals)),
                  &(&1.value == val_value)
                )

            def value_by_name(unquote(attr), val_name),
              do:
                Enum.find(
                  unquote(Macro.escape(vals)),
                  &(&1.name == val_name)
                )
          end
        end
      end

    IO.puts("Compiling #{mod}")

    value_doc_funs = if value_funs == [], do: [], else: [Helpers.generate_value_doc_helpers()]

    module_body =
      [Helpers.generate_attribute_doc_helpers()] ++
        attribute_funs ++ value_funs ++ value_doc_funs

    Module.create(mod, module_body, Macro.Env.location(__ENV__))
  end

  def attribute_by_id(id), do: raise(EntryNotFoundError, type: :attribute, key: id)
  def attribute_by_name(name), do: raise(EntryNotFoundError, type: :attribute, key: name)
  def value_by_value(attr, _val), do: raise(EntryNotFoundError, type: :value, key: attr)
  def value_by_name(attr, _val_name), do: raise(EntryNotFoundError, type: :value, key: attr)
  def vendor_by_id(id), do: raise(EntryNotFoundError, type: :vendor, key: id)
  def vendor_by_name(name), do: raise(EntryNotFoundError, type: :vendor, key: name)
end
