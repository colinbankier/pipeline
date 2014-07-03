defmodule Pipeline.Mixfile do
  use Mix.Project

  def project do
    [ app: :pipeline,
      version: "0.0.1",
      compilers: [:elixir, :app],
      env: [prod: [compile_path: "ebin"]],
      compile_path: "tmp/#{Mix.env}/pipeline/ebin",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [
      applications: [:cowboy, :exec, :postgrex, :ecto],
      mod: {PipelineApp, []}
    ]
  end

  defp deps do
    [
      {:postgrex, ">= 0.0.0"},
      {:ecto, "~> 0.2.0"},
      {:exec, [github: "saleyn/erlexec", app: "ebin/exec.app",
        ref: "a84d95f46422163c24ffef7a123efe9b15d56253"]},
      { :cowboy, github: "extend/cowboy" },
      { :jsex, github: "talentdeficit/jsex" },
    ]
  end
end
