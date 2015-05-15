defmodule Issues.Mixfile do
  use Mix.Project

  def project do
    [app: :issues,
     version: "0.0.1",
     elixir: "~> 1.0",
     escript: escript_config,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [applications: [:logger, :httpoison, :jsx]]
  end

  defp deps do
    [
      {:httpoison, "~> 0.6"},
      {:jsx, "~> 2.6"}
    ]
  end

  defp escript_config do
    [main_module: Issues.CLI]
  end

end