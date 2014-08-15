defmodule Pipeline.Mixfile do
  use Mix.Project

  def project do
    [ app: :pipeline,
      version: "0.0.1",
      elixir: "~> 0.14.2",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [
      applications: [:phoenix, :exec, :postgrex, :ecto, :yamerl],
      mod: {PipelineApp, []}
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
      {:cowboy, "~> 0.10.0", github: "extend/cowboy", optional: true}
    ]
  end
end
