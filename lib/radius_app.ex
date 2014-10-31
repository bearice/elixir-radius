defmodule RadiusApp do
  use Application
  def start(_type,_args) do
    RadiusApp.Supervisor.start_link()
  end
end
defmodule RadiusApp.Supervisor do
  use Supervisor
  def start_link() do
    Supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    dict = Application.get_env(:elixir_radius, :dict)
    children = [
      worker(RadiusDict, [dict])
    ]
    supervise(children, strategy: :one_for_one)
  end
end
