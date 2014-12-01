defmodule Pipeline.Controllers.SourceRepos do
  use Phoenix.Controller
  alias Pipeline.Models.SourceRepo

  def index(conn, _params) do
    source_repos = SourceRepo.all
    {:ok, body} = JSX.encode(%{source_repos: source_repos})
    IO.inspect body
    json conn, body
  end

  def create(conn, params) do
    IO.inspect params
    source_repo = %Pipeline.Models.SourceRepo{name: params["name"]}
    try do
      source_repo = Repo.insert source_repo
      {:ok, body} = JSX.encode source_repo
      json conn, body
    rescue
      e in Postgrex.Error ->
        {:ok, body} = JSX.encode params
        json conn, body
    end
  end

  def destroy(conn, params) do
    source_repo = Repo.get SourceRepo, params["id"]
    Repo.delete source_repo
    {:ok, body} = JSX.encode params
    json conn, body
  end

  def show(conn, params) do
    # pipeline = Pipeline.find(String.to_integer(params["id"]))
    # {:ok, body} = JSX.encode pipeline
    json conn, "{\"body\": 3}"
  end
end
