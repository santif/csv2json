defmodule Csv2Json.Mixfile do
  use Mix.Project

  def project do
    [app: :csv2json,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     escript: escript()]
  end

  def application do
    [extra_applications: [:logger]]
  end

  def escript do
    [main_module: Csv2Json]
  end

  defp deps do
    [{:poison, "~> 3.1"},
     {:csv, "~> 2.0"}]
  end
end
