defmodule RadiusProxy.Mixfile do
  use Mix.Project

  def project do
    [app: :elixir_radius,
     version: "0.1.0",
     elixir: "~> 1.0",
     description: desc,
     package: package,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [
      applications: [:logger,:crypto],
      registered: [RadiusDict],
      mod: {RadiusApp,[]},
      env: [
        dict: "dict/dictionary"
      ]
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
  defp deps do
    [
      {:earmark, "~> 0.1", only: :dev},
      {:ex_doc, "~> 0.6", only: :dev}
      #  {:socket,"~> 0.2.8"}
    ]
  end
  defp desc do
    """
    Decode & encode RADIUS packets
    """
  end
  defp package do
    [
      files: ["lib","src","mix.exs","example.exs","README.md","LICENSE","dict"],
      contributors: ["Bearice Ren"],
      licenses: ["MIT License"],
      links: %{"Github" => "https://github.com/bearice/elixir-radius"}
    ]
  end
end
