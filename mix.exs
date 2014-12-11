defmodule Pipeline.Mixfile do
  use Mix.Project

  def project do
    [ app: :pipeline,
      version: "0.0.1",
      elixir: "~> 1.0.0",
      elixirc_paths: ["lib", "web"],
      compilers: [:phoenix] ++ Mix.compilers,
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [
      applications: [:phoenix, :cowboy, :logger, :exec, :postgrex, :ecto, :yamerl],
      mod: {Pipeline, []}
    ]
  end

  defp deps do
    [
      {:postgrex, ">= 0.0.0"},
      {:ecto, "~> 0.2.0"},
      {:exec, [github: "saleyn/erlexec", app: "ebin/exec.app",
        ref: "a84d95f46422163c24ffef7a123efe9b15d56253"]},
      { :exjsx, github: "talentdeficit/jsex" },
      {:phoenix, [github: "phoenixframework/phoenix", ref: "v0.6.1"]},
      {:yamerl, [github: "yakaz/yamerl"]},
      {:cowboy, "~> 1.0"},
      {:httpoison, "~> 0.4"}
    ]
  end
end
