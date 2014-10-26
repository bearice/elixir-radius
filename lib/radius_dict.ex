defmodule RadiusDict do
  require GenServer
  require Logger
  require Record

  Record.defrecord :attribute, [name: nil, id: nil, type: nil, opts: nil]
  Record.defrecord :vendor,    [name: nil, id: nil, format: nil]
  Record.defrecord :value,     [name: nil, id: nil]

  def init(_) do
    {:ok,{}}
  end

  def handle_call({:lookup,query},_from,state) do
    {:reply, :ok, state}
  end #handle_call/3

  def init_ets() do
    :ets.new :radius_attribute_name, [:set, :protected, :named_table, {:keypos,2}]
    :ets.new :radius_attribute_id,   [:set, :protected, :named_table, {:keypos,3}]
    :ets.new :radius_vendor_name,    [:set, :protected, :named_table, {:keypos,2}]
    :ets.new :radius_vendor_id,      [:set, :protected, :named_table, {:keypos,3}]
    :ets.new :radius_value_name,     [:set, :protected, :named_table, {:keypos,2}]
    :ets.new :radius_value_id,       [:set, :protected, :named_table, {:keypos,3}]
    :ok
  end

  def add_vendor(v) when Record.is_record(v,:vendor) do
    :ets.insert_new :radius_vendor_name, v
    :ets.insert_new :radius_vendor_id,   v 
  end

  def add_attribute(v) when Record.is_record(v,:attribute) do
    :ets.insert_new :radius_attribute_name, v
    :ets.insert_new :radius_attribute_id,   v 
  end

  def add_value(v) when Record.is_record(v,:value) do
    :ets.insert_new :radius_value_name, v
    :ets.insert_new :radius_value_id,   v 
  end

  def find_vendor(val) when is_binary(val) do
    :ets.lookup :radius_vendor_name, val
  end
  def find_vendor(val) when is_integer(val) do
    :ets.lookup :radius_vendor_id, val
  end

  def find_attribute(val) when is_binary(val) do
    :ets.lookup :radius_attribute_name, val
  end
  def find_attribute(val) when is_integer(val) do
    :ets.lookup :radius_attribute_id, val
  end

  def reload_dict() do
  end #reload_dict

  def load(path) when is_binary(path) do
    ctx = %{path: path, vendor: %{name: nil, id: 0}}
    load ctx
  end

  def load(ctx) when is_map(ctx) do
    path = ctx.path
    Logger.info "Loading dict: #{path}"
    try do
      spec = File.read!(path) |> String.to_char_list |> _tokenlize! |> _parse!
      process_dict(ctx,spec)
    rescue
      e -> 
        Logger.error inspect e
        e
    after
      Logger.flush
    end
  end

  def _tokenlize!(string) do
    case :radius_dict_lex.string string do
      {:ok,tokens, _} -> tokens 
      {:error,{line,_,msg}} = e ->
        Logger.error "Error at line #{line}: #{inspect msg}"
        raise e
      e ->
        Logger.error "Error: #{inspect e}"
        raise e
    end
  end
  def _parse!(tokens) do
    case :radius_dict_parser.parse(tokens) do
      {:ok,spec} -> spec
      {:error,{line,_,msg}} = e ->
        Logger.debug inspect _token_near(tokens,line,2)
        Logger.error "Error at line #{line}: #{inspect msg}"
        raise e
    end
  end

  def _token_near(l,pos,range) do
    _token_near [],l,pos+range,pos-range
  end
  def _token_near(acc,[],_,_) do
    :lists.reverse acc
  end
  def _token_near(acc,[h|t],max,min) do
    line = case h do
      {_,line} -> line
      {_,line,_} -> line
    end
    acc1 = cond do
      line <= max and line >= min -> [h|acc]
      true -> acc
    end
    _token_near acc1,t,max,min
  end

  def process_dict(_,[]) do
    :ok
  end
  def process_dict(ctx,[{:include,name}|tail]) do
    base = Path.dirname ctx.path
    name = Path.join base,name
    case load name do
      :ok -> process_dict ctx,tail
      e -> e
    end
  end
  def process_dict(ctx,[{:vendor,name,id,format}|tail]) do
    add_vendor vendor(name: to_string(name), id: id, format: format)
    process_dict ctx,tail
  end
  def process_dict(ctx,[{:vendor_begin,name}|tail]) do
    name = to_string name
    case find_vendor name do
      [{:vendor,vname,vid,_}] ->
        ctx = %{ctx| vendor: %{name: vname, id: vid} }
        process_dict ctx,tail
      _ ->
        raise {:error,:begin_vendor_not_exist, name}
    end
  end
  def process_dict(ctx,[{:vendor_end,name}|tail]) do
    name = to_string(name)
    v = ctx.vendor
    if v.name == nil, do: raise {:error,:unexpected_end_vendor}
    if v.name == name do
      ctx = %{ctx| vendor: %{name: nil, id: 0} }
      process_dict ctx,tail
    else
      raise {:error,:end_vendor_not_match, name}
    end
  end
  def process_dict(ctx,[{:attribute,name,id,type,opts}|tail]) do
    add_attribute attribute(name: to_string(name), id: {ctx.vendor.id,id}, type: type, opts: opts)
    process_dict ctx,tail
  end
  def process_dict(ctx,[{:value,attr,desc,id}|tail]) do
    attr = to_string(attr)
    case find_attribute(attr) do
      [{:attribute,_,aid,_,_}] ->
        add_attribute attribute(name: to_string(desc), id: {aid,id})
        process_dict ctx,tail
      [] ->
        raise {:error,:attribute_not_defined, attr}
    end
  end
  def process_dict(ctx,[head|tail]) do
    Logger.warn "Unknown command: #{inspect head}"
    process_dict ctx,tail
  end

  #exports
  def start_link(default) do
    GenServer.start_link(__MODULE__,default)
  end #start_link/1

  def lookup(type,val)  do
    GenServer.call(__MODULE__,:lookup,{type,val})
  end #lookup

end
