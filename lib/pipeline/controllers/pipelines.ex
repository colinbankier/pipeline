defmodule Pipeline.Controllers.Pipelines do
  use Phoenix.Controller
  import Ecto.Query
  alias Pipeline.Models.Pipeline

  def index(conn, _params) do
    render conn, "index"
  end

  def create(conn, params) do
    IO.inspect params
    pipeline = %Pipeline{name: params["name"]}
    pipeline = Repo.insert pipeline

    body = """
    {"id": #{pipeline.id}, "name": "#{pipeline.name}"}
    """
    IO.puts body
    json conn, body
  end

  def show(conn, params) do
    id = String.to_integer params["id"]
    query = from p in Pipeline,
      where: p.id == ^id,
      limit: 1

    pipeline = Repo.one(query)
    body = """
    {"id": #{pipeline.id}, "name": "#{pipeline.name}"}
    """
    json conn, body
  end
end
