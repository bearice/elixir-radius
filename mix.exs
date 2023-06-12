defmodule RadiusProxy.Mixfile do
  use Mix.Project

  def project do
    [
      app: :elixir_radius,
      version: "2.0.0",
      elixir: "~> 1.12",
      deps: deps(),
      name: "Radius",
      description: desc(),
      package: package(),
      source_url: "https://github.com/bearice/elixir-radius",
      docs: docs()
    ]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application() do
    [
      extra_applications: [:logger, :crypto]
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
      {:ex_doc, "~> 0.19", only: :dev},
      {:nimble_parsec, "~> 1.3", only: :dev}
    ]
  end

  defp desc() do
    """
    Decode & encode RADIUS packets
    """
  end

  defp package() do
    [
      files: ["lib", "mix.exs", "example.exs", "README.md", "LICENSE", "dicts"],
      contributors: ["Bearice Ren", "Guilherme Balena Versiani", "Timmo Verlaan"],
      licenses: ["MIT License"],
      links: %{"Github" => "https://github.com/bearice/elixir-radius"}
    ]
  end

  defp docs() do
    [
      main: "README",
      extras: ["README.md"],
      groups_for_modules: [
        "Vendor Dictionaries": ~r/Radius\.Dict\.Vendor.+/
      ],
      groups_for_docs: [
        "Lookup Functions": &(&1[:group] == :lookup),
        Attributes: &(&1[:group] == :attributes),
        Values: &(&1[:group] == :values)
      ]
    ]
  end
end
