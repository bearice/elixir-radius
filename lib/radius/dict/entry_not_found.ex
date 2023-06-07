defmodule Radius.Dict.EntryNotFoundError do
  defexception [:type, :key]

  def message(e) do
    "Entry #{e.type} not found for key: #{inspect(e.key)}"
  end
end
