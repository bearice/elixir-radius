defmodule Radius.Supervisor do
  use Supervisor

  def start_link() do
    Supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    dict =
      [Application.app_dir(:elixir_radius), "priv", "dictionary"]
      |> Path.join()

    children = [
      worker(Radius.Dict, [dict])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
