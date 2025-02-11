defmodule TowerDiscord.MixProject do
  use Mix.Project

  def project do
    [
      name: "Tower Discord",
      app: :tower_discord,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      source_url: "https://github.com/kristerv/tower_discord",
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:tower, "~> 0.8.0"},
      {:ex_doc, "~> 0.31", only: :dev, runtime: false},
      {:req, "~> 0.5.0"}
    ]
  end

  defp docs do
    [
      main: "TowerTelegram",
      extras: ["README.md"]
    ]
  end

  defp package do
    [
      description:
        "Error tracking and reporting to a Telegram chat (group or channel) using Tower.",
      files: ~w(lib LICENSE mix.exs README.md CHANGELOG.md),
      licenses: ["Apache-2.0"],
      links: %{
        "GitHub" => "https://github.com/kristerv/tower_discord",
        "Tower package" => "https://hex.pm/packages/tower"
      }
    ]
  end
end
