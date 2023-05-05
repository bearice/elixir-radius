defmodule Radius.Dict do
  use GenServer
  require Logger

  def init(file) do
    init_ets()
    load(file)
    {:ok, %{file: file}}
  end

  # init/1

  # def handle_call(:reload,_from,state) do
  #  ctx = load(state.file)
  #  {:reply, {:ok,ctx}, state}
  # end #handle_call/3

  # exports
  def start_link(file) do
    GenServer.start_link(__MODULE__, file, name: __MODULE__)
  end

  # start_link/1

  # def reload()  do
  #  GenServer.call(__MODULE__,:reload)
  # end #reload

  defmodule EntryNotFoundError do
    defexception [:type, :key]

    def message(e) do
      "Enrty #{e.type} not found for key: #{inspect(e.key)}"
    end
  end

  defmodule DictEntry do
    defmacro __using__(_) do
      quote do
        def init! do
          DictEntry.__init__(__MODULE__)
        end

        def insert(val) do
          DictEntry.__insert__(__MODULE__, val)
        end

        def lookup(key) do
          try do
            lookup!(key)
          rescue
            e in EntryNotFoundError -> []
          end
        end

        def lookup!(key) do
          DictEntry.__lookup__(__MODULE__, key)
        end

        def on_insert(val) do
          val
        end

        def on_load(val) do
          val
        end

        defoverridable on_insert: 1, on_load: 1
      end
    end

    def __init__(mod) do
      :ets.new(mod, [:set, :protected, :named_table])
    end

    def __insert__(mod, val) do
      val = mod.on_insert(val)
      keys = val |> mod.index_for

      Enum.map(keys, fn x ->
        if not :ets.insert_new(mod, {x, val}) do
          # Logger.warn "ignored duplicat #{mod}: #{inspect x} at #{val.file}:#{val.line} \nObject: #{inspect val, pretty: true}"
          :ok
        end
      end)
    end

    def __lookup__(mod, [key]) do
      __lookup__(mod, key)
    end

    def __lookup__(mod, key) do
      try do
        :ets.lookup_element(mod, key, 2)
      rescue
        ArgumentError ->
          raise EntryNotFoundError, type: mod, key: key
      end
    end
  end

  # module DictEntry

  defmodule Vendor do
    use DictEntry
    defstruct id: nil, name: nil, format: {1, 1}, file: "(unknown)", line: 0

    def index_for(val) do
      [id: val.id, name: val.name]
    end

    def by_name(nil) do
      %Vendor{}
    end

    def by_name(name) do
      lookup!(name: name)
    end

    def by_id(id) do
      lookup!(id: id)
    end
  end

  # module Vendor

  defmodule Attribute do
    use DictEntry
    defstruct id: nil, name: nil, type: nil, opts: [], vendor: nil, file: "(unknown)", line: 0

    def on_insert(val) do
      v = Vendor.by_name(val.vendor)
      %{val | vendor: v}
    end

    def index_for(val) do
      [id: {val.vendor.id, val.id}, name: val.name]
    end

    def by_name(name) do
      lookup!(name: name)
    end

    def by_id(vendor \\ nil, id) do
      lookup!(id: {vendor, id})
    end
  end

  # module Attribute

  defmodule Value do
    use DictEntry
    defstruct name: nil, attr: nil, value: nil, file: "(unknown)", line: 0

    def on_insert(val) do
      a = Attribute.lookup!(name: val.attr)
      %{val | attr: a}
    end

    def index_for(val) do
      [
        value: {val.attr.vendor.id, val.attr.id, val.value},
        name: {val.attr.vendor.name, val.attr.name, val.name}
      ]
    end

    def by_name(vendor \\ nil, attr, name) do
      lookup!(name: {vendor, attr, name})
    end

    def by_value(vendor \\ nil, attr, name) do
      lookup!(value: {vendor, attr, name})
    end
  end

  # module Value

  defp init_ets() do
    Vendor.init!()
    Attribute.init!()
    Value.init!()
    :ok
  end

  defmodule ParserError do
    defexception file: "<unknown>", line: -1, msg: nil

    def exception({:error, {line, _, msg}}) do
      %ParserError{line: line, msg: msg}
    end

    def exception({:error, {line, _, msg}, _}) do
      %ParserError{line: line, msg: msg}
    end

    def message(e) do
      "ParserError: at file: #{e.file}:#{e.line} #{e.msg}"
    end
  end

  defp load(path) when is_binary(path) do
    ctx = %{path: [path], vendor: nil, vendors: [], attrs: [], values: []}
    ctx = load(ctx)
    Enum.each(ctx.vendors, &Vendor.insert/1)
    Enum.each(ctx.attrs, &Attribute.insert/1)
    Enum.each(ctx.values, &Value.insert/1)
    ctx
  end

  defp load(ctx) when is_map(ctx) do
    path = hd(ctx.path)
    # Logger.debug "Loading dict: #{path}"
    try do
      File.read!(path)
      |> String.to_charlist()
      |> tokenlize!
      |> parse!
      |> (&process_dict(ctx, &1)).()
    rescue
      e in ParserError -> reraise %{e | file: path}, System.stacktrace()
      e -> reraise e, System.stacktrace()
    after
      Logger.flush()
    end
  end

  defp tokenlize!(string) do
    case :radius_dict_lex.string(string) do
      {:ok, tokens, _} -> tokens
      e -> raise ParserError, e
    end
  end

  defp parse!(tokens) do
    case :radius_dict_parser.parse(tokens) do
      {:ok, spec} ->
        spec

      e ->
        e = ParserError.exception(e)
        Logger.debug(inspect(_token_near(tokens, [], e.line - 2, e.line + 2)))
        raise e
    end
  end

  defp _token_near(acc, [], _, _) do
    :lists.reverse(acc)
  end

  defp _token_near(acc, [h | t], min, max) when :erlang.element(2, h) in min..max do
    _token_near([h | acc], t, max, min)
  end

  defp _token_near(acc, [_ | t], min, max) do
    _token_near(acc, t, max, min)
  end

  defp process_dict(ctx, []) do
    ctx
  end

  defp process_dict(ctx, [{:include, name} | tail]) do
    target =
      ctx.path
      |> Path.dirname()
      |> Path.join(name)

    ctx = %{ctx | path: [target | ctx.path]}
    ctx = load(ctx)
    ctx = %{ctx | path: Enum.drop(ctx.path, 1)}
    process_dict(ctx, tail)
  end

  defp process_dict(ctx, [{:vendor_begin, name, _line} | tail]) do
    name = to_string(name)
    ctx = %{ctx | vendor: name}
    process_dict(ctx, tail)
  end

  defp process_dict(ctx, [{:vendor_end, name, _line} | tail]) do
    name = to_string(name)

    if ctx.vendor == name do
      ctx = %{ctx | vendor: nil}
      process_dict(ctx, tail)
    else
      raise {:error, :end_vendor_not_match, name}
    end
  end

  defp process_dict(ctx, [{:vendor, name, id, format, line} | tail]) do
    name = to_string(name)
    v = %Vendor{name: name, id: id, format: format, file: hd(ctx.path), line: line}
    ctx = %{ctx | vendors: [v | ctx.vendors]}
    process_dict(ctx, tail)
  end

  defp process_dict(ctx, [{:attribute, name, id, type, opts, line} | tail]) do
    name = to_string(name)

    a = %Attribute{
      name: name,
      id: id,
      type: type,
      opts: opts,
      vendor: ctx.vendor,
      file: hd(ctx.path),
      line: line
    }

    ctx = %{ctx | attrs: [a | ctx.attrs]}
    process_dict(ctx, tail)
  end

  defp process_dict(ctx, [{:value, attr, desc, id, line} | tail]) do
    attr = to_string(attr)
    desc = to_string(desc)
    v = %Value{name: desc, attr: attr, value: id, file: hd(ctx.path), line: line}
    ctx = %{ctx | values: [v | ctx.values]}
    process_dict(ctx, tail)
  end

  defp process_dict(ctx, [head | tail]) do
    Logger.warn("Unknown command: #{inspect(head)}")
    process_dict(ctx, tail)
  end
end
