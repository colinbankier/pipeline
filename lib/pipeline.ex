defmodule PipelineApp do
  use Application

  # See http://elixir-lang.org/docs/stable/Application.Behaviour.html
  # for more information on OTP Applications
  def start(_type, _args) do
    IO.puts "App start"
    PipelineApp.Supervisor.start_link
  end

  def default_working_dir do
    Path.join(System.get_env("HOME"), ".pipeline")
  end
end
