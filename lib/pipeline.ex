defmodule Pipeline do
  use Application.Behaviour

  @doc """
  The application callback used to start this
  application and its Dynamos.
  """
  def start(_type, _args) do
    Pipeline.Sup.start_link([])
  end
end

defmodule Pipeline.Sup do
  use Supervisor.Behaviour

  def start_link(stack) do
    :supervisor.start_link(__MODULE__ , stack)
  end

  def init(stack) do
    tree = [
      worker(Pipeline.Repo, []),
      supervisor(Pipeline.Dynamo, [])
      ]
    supervise(tree, strategy: :one_for_all)
  end
end
