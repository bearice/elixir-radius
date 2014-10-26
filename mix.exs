defmodule RadiusProxy.Mixfile do
  use Mix.Project

  def project do
    [app: :radius_proxy,
     version: "0.0.1",
     elixir: "~> 1.0",
     escript: escript,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      #  {:socket,"~> 0.2.8"}
    ]
  end

  def escript do
    [main_module: RadiusProxy]
  end
end
