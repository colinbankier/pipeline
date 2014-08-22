defmodule Pipeline.Mixfile do
  use Mix.Project

  def project do
    [ app: :pipeline,
      version: "0.0.1",
      elixir: "~> 0.15.1",
      elixirc_paths: ["lib", "web"],
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [
      applications: [:phoenix, :exec, :postgrex, :ecto, :yamerl, :elixir_talk],
      mod: {Pipeline, []}
    ]
  end

  defp deps do
    [
      {:postgrex, ">= 0.0.0"},
      {:ecto, "~> 0.2.0"},
      {:exec, [github: "saleyn/erlexec", app: "ebin/exec.app",
        ref: "a84d95f46422163c24ffef7a123efe9b15d56253"]},
      { :jsex, github: "talentdeficit/jsex" },
      # {:phoenix, "0.3.0"},
      {:phoenix, [github: "phoenixframework/phoenix", ref: "master"]},
      {:yamerl, [github: "yakaz/yamerl"]},
      {:elixir_talk, [github: "jsvisa/elixir_talk"]},
      {:cowboy, "~> 1.0.0", github: "extend/cowboy", optional: true, override: true}
    ]
  end
end
