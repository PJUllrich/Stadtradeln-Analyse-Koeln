defmodule Stadtradeln.Mixfile do
  use Mix.Project

  def application do
    []
  end

  def project do
    [app: :code_samples, version: "1.0.0", deps: deps()]
  end

  defp deps do
    [
      {:csv, ">= 0.0.0"},
      {:geo, "~> 3.0"},
      {:jason, ">= 0.0.0"}
    ]
  end
end
