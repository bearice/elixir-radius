defmodule RadiusProxy.Mixfile do
  use Mix.Project

  def project do
    [
      app: :elixir_radius,
      version: "1.0.0",
      elixir: "~> 1.12",
      description: desc(),
      package: package(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application() do
    [
      applications: [:logger, :crypto],
      registered: [Radius.Dict],
      mod: {Radius.Application, []}
    ]
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
  defp deps() do
    [
      {:earmark, "~> 1.4", only: :dev},
      {:ex_doc, "~> 0.19", only: :dev}
      #  {:socket,"~> 0.2.8"}
    ]
  end

  defp desc() do
    """
    Decode & encode RADIUS packets
    """
  end

  defp package() do
    [
      files: ["lib", "src", "mix.exs", "example.exs", "README.md", "LICENSE", "priv"],
      contributors: ["Bearice Ren", "Guilherme Balena Versiani", "Timmo Verlaan"],
      licenses: ["MIT License"],
      links: %{"Github" => "https://github.com/bearice/elixir-radius"}
    ]
  end
end
