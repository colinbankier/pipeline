defmodule Pipeline.Controllers.Pipelines do
  use Phoenix.Controller
  alias Pipeline.Models.Pipeline

  def index(conn, _params) do
    pipelines = Pipeline.top_level_pipelines
    {:ok, body} = JSEX.encode(%{pipelines: pipelines})
    json conn, body
  end

  def create(conn, params) do
    IO.inspect params
    pipeline = %Pipeline{name: params["name"]}
    pipeline = Repo.insert pipeline

    {:ok, body} = JSEX.encode pipeline
    json conn, body
  end

  def show(conn, params) do
    pipeline = Pipeline.find(String.to_integer(params["id"]))
    {:ok, body} = JSEX.encode pipeline
    json conn, body
  end
end
