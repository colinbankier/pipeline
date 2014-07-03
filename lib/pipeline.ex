defmodule PipelineApp do
  use Application

  def start(_type, _args) do
    IO.puts "App start"
    PipelineApp.Supervisor.start_link
  end

  def default_working_dir do
    Path.join(System.get_env("HOME"), ".pipeline")
  end
end

defmodule PipelineApp.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
    ]
    :ets.new :pipeline_results, [:named_table, :public]
    :ets.new :task_output, [:named_table, :public]

    supervise(children, strategy: :one_for_one)
  end
end
