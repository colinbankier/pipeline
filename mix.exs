defmodule Pipeline.Mixfile do
  use Mix.Project

  def project do
    [ 
      app: :pipeline,
      version: "0.0.1",
      deps: deps
    ]
  end

  def application do
    [
      applications: [:weber, :exec],
      mod: {Pipeline, []}
    ]
  end

  defp deps do
    [ 
      { :weber, github: "0xAX/weber" },
      {:exec, "v1.0-84-ga84d95f", [github: "saleyn/erlexec", app: "ebin/exec.app", 
      ref: "a84d95f46422163c24ffef7a123efe9b15d56253"]}
    ]
  end
end
