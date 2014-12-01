defmodule Pipeline.Controllers.Pipelines do
  use Phoenix.Controller
  import Pipeline.Parser
  alias Pipeline.Models.Pipeline

  def index(conn, _params) do
    {:ok, body} = JSX.encode(%{pipelines: list_pipelines})
    json conn, body
  end

  def create(conn, params) do
    IO.inspect params
    pipeline = %Pipeline{name: params["name"]}
    pipeline = Repo.insert pipeline

    {:ok, body} = JSX.encode pipeline
    json conn, body
  end

  def show(conn, params) do
    name = URI.decode params["id"]
    {:ok, body} = JSX.encode find_by_path(name)
    json conn, body
  end
end
