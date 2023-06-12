defmodule Radius.Dict.Helpers do
  @moduledoc false
  defmacro define_attribute_doc_helpers() do
    generate_attribute_doc_helpers()
  end

  defmacro define_attribute_functions(attribute) do
    generate_attribute_functions(attribute)
  end

  defmacro define_value_doc_helpers() do
    generate_value_doc_helpers()
  end

  defmacro define_value_functions(val) do
    generate_value_functions(val)
  end

  def generate_attribute_doc_helpers() do
    quote do
      @doc """
      Get attribute struct based on attribute id
      """
      @doc group: :lookup
      def attribute_by_id(attr_id)

      @doc """
      Get attribute struct based on attribute name
      """
      @doc group: :lookup
      def attribute_by_name(attr_name)
    end
  end

  def generate_attribute_functions(attribute) do
    quote bind_quoted: [attribute: attribute] do
      attr_fun_name = "attr_#{attribute.name}" |> String.replace("-", "_") |> String.to_atom()

      @doc group: :attributes
      defmacro unquote(attr_fun_name)(), do: unquote(attribute.id)
      @doc group: :attributes
      defmacro unquote(attr_fun_name)(val), do: {unquote(attribute.id), val}
      def attribute_by_id(unquote(attribute.id)), do: unquote(Macro.escape(attribute))
      def attribute_by_name(unquote(attribute.name)), do: unquote(Macro.escape(attribute))
    end
  end

  def generate_value_doc_helpers() do
    quote do
      @doc """
      Get value struct based on attribute name and value name
      """
      @doc group: :lookup
      def value_by_name(attr_name, value_name)

      @doc """
      Get value struct based on attribute name and the value
      """
      @doc group: :lookup
      def value_by_value(attr_name, value)
    end
  end

  def generate_value_functions(val) do
    quote bind_quoted: [val: val] do
      val_fun_name = "val_#{val.attr}_#{val.name}" |> String.replace("-", "_") |> String.to_atom()

      @doc group: :values
      defmacro unquote(val_fun_name)(), do: unquote(val.value)
      def value_by_value(unquote(val.attr), unquote(val.value)), do: unquote(Macro.escape(val))
      def value_by_name(unquote(val.attr), unquote(val.name)), do: unquote(Macro.escape(val))
    end
  end

  def safe_name(name) do
    name |> String.replace("-", "_") |> String.to_atom()
  end
end
