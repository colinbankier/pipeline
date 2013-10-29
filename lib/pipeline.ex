defmodule PipelineApp do
  use Application.Behaviour

  @doc """
  The application callback used to start this
  application and its Dynamos.
  """
  def start(_type, _args) do
    PipelineApp.Supervisor.start_link([])
  end
end

defmodule PipelineApp.Supervisor do
  use Supervisor.Behaviour

  def start_link(stack) do
    :supervisor.start_link(__MODULE__ , stack)
  end

  def init(stack) do
    tree = [
      worker(Repo, []),
      supervisor(PipelineApp.Dynamo, [])
      ]
    supervise(tree, strategy: :one_for_all)
  end
end
