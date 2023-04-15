defmodule UpLearn.MixProject do
  use Mix.Project

  def project do
    [
      app: :up_learn,
      version: "0.1.0",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {UpLearn.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "~> 1.4"},
      {:httpoison, "~> 2.0"},
      {:ecto, "~> 3.8"},
      {:floki, "~> 0.34.0"},
      {:credo, "~> 1.7.0", only: [:dev, :test], runtime: false},
      {:mock, "~> 0.3.7", only: :test, runtime: false},
      {:bypass, "~> 2.1", only: :test}
    ]
  end
end
