defmodule Pipeline.Mixfile do
  use Mix.Project

  def project do
    [ app: :pipeline,
      version: "0.0.1",
      dynamos: [Pipeline.Dynamo],
      compilers: [:elixir, :dynamo, :app],
      env: [prod: [compile_path: "ebin"]],
      compile_path: "tmp/#{Mix.env}/pipeline/ebin",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [ applications: [:cowboy, :dynamo, :exec],
      mod: { Pipeline, [] } ]
  end

  defp deps do
    [ { :cowboy, github: "extend/cowboy" },
      { :dynamo, "0.1.0-dev", github: "elixir-lang/dynamo" },
      {:exec, "v1.0-84-ga84d95f", [github: "saleyn/erlexec", app: "ebin/exec.app", 
      ref: "a84d95f46422163c24ffef7a123efe9b15d56253"]}
    ]
  end
end
