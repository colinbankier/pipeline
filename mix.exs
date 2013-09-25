defmodule Pipeline.Mixfile do
  use Mix.Project

  def project do
    [ app: :pipeline,
      version: "0.0.1",
      elixir: "~> 0.10.2",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [ applications: [:exec] ]
  end

  # Returns the list of dependencies in the format:
  # { :foobar, "~> 0.1", git: "https://github.com/elixir-lang/foobar.git" }
  defp deps do
    [      
      {:exec, "v1.0-84-ga84d95f", [github: "saleyn/erlexec", app: "ebin/exec.app", ref: "a84d95f46422163c24ffef7a123efe9b15d56253"]},
    ]
  end
end
