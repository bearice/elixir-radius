defmodule Radius.Application do
  use Application

  def start(_type, _args) do
    Radius.Supervisor.start_link()
  end
end
