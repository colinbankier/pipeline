defmodule Pipeline.Controllers.SourceRepos do
  use Phoenix.Controller
  alias Pipeline.Models.SourceRepo

  def index(conn, _params) do
    source_repos = SourceRepo.all
    {:ok, body} = JSEX.encode(%{source_repos: source_repos})
    IO.inspect body
    json conn, body
  end

  def create(conn, params) do
    IO.inspect params
    source_repo = %SourceRepo{name: params["name"]}
    source_repo = Repo.insert source_repo

    {:ok, body} = JSEX.encode source_repo
    IO.inspect body
    json conn, body
  end

  def show(conn, params) do
    # pipeline = Pipeline.find(String.to_integer(params["id"]))
    # {:ok, body} = JSEX.encode pipeline
    json conn, "body"
  end
end
