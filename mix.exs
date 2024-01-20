defmodule GenstageDemo2023.MixProject do
  use Mix.Project

  def project do
    [
      app: :genstage_demo_2023,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {GenstageDemo2023.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}

      {:ecto_sql, "~> 3.0"},
      {:postgrex, "~> 0.17.4"},
      {:gen_stage, "~> 1.2.1"},
    ]
  end
end
