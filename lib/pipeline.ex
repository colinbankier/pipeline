defmodule PipelineApp do
  use Application.Behaviour

  @doc """
  The application callback used to start this
  application and its Dynamos.
  """
  def start(_type, _args) do
    PipelineApp.Supervisor.start_link([])
  end

  def default_working_dir do
    Path.join(System.get_env("HOME"), ".pipeline")
  end
end

defmodule PipelineApp.Supervisor do
  use Supervisor.Behaviour
  use Rethinkdb

  def start_link(stack) do
    :supervisor.start_link(__MODULE__ , stack)
  end

  def init(stack) do
    #:ets.new :pipeline_results, [:named_table, :public,
    #  {:keypos, Result.PipelineResult.__record__(:index, :id) + 1}]
    :ets.new :pipeline_results, [:named_table, :public]
    :ets.new :task_output, [:named_table, :public]
    r.connect("rethinkdb://localhost:28015/test").repl
    tree = [
      #worker(Repo, []),
      supervisor(PipelineApp.Dynamo, [])
      ]
    supervise(tree, strategy: :one_for_all)
  end
end
