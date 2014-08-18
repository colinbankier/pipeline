defmodule Pipeline.Controllers.SourceRepos do
  use Phoenix.Controller

  def index(conn, _params) do
    # pipelines = Pipeline.top_level_pipelines
    # {:ok, body} = JSEX.encode(%{pipelines: pipelines})
    json conn, "body"
  end

  def create(conn, params) do
    IO.inspect params
    source_repo = %SourceRepo{path: params["path"]}
    source_repo = Repo.insert source_repo

    {:ok, body} = JSEX.encode source_repo
    json conn, body
  end

  def show(conn, params) do
    # pipeline = Pipeline.find(String.to_integer(params["id"]))
    # {:ok, body} = JSEX.encode pipeline
    json conn, "body"
  end
end
