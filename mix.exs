defmodule EffectEcto.MixProject do
  use Mix.Project

  def project do
    [
      app: :effect_ecto,
      version: "0.2.0",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto, "~> 3.0"},
      {:ecto_sql, "~> 3.0", only: [:test]},
      {:effect, git: "https://github.com/yunmikun2/effect", tag: "v0.2.0"},
      {:ex_doc, "~> 0.24", only: [:dev], runtime: false},
      {:postgrex, ">= 0.1.6", only: [:test]}
    ]
  end

  defp aliases do
    [
      test: ["ecto.drop", "ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
