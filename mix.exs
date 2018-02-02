defmodule GetRates.Mixfile do
  use Mix.Project

  def project do
    [
      app: :get_rates,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {GetRatesApp, []},
      extra_applications: [:logger, :postgrex, :ecto]
#      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:cowboy, "~> 2.2.2"},
      {:poison, "~> 3.1"},
      {:postgrex, "~> 0.13.3"},
      {:ecto, "~> 2.2.8"}
    ]
  end
end
