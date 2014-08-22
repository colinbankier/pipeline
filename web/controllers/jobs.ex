defmodule Pipeline.Controllers.Jobs do
  use Phoenix.Controller
  import Ecto.Query
  alias Models.Job
  alias Pipeline.Parser

  def create(conn, params) do
    {:ok, body} = params["source_repo"] |>
    Parser.find_by_path |>
    create_job |>
    Repo.insert |>
    JSEX.encode

    json conn, body
  end

  def create_job task do
    %Job{path: [task.name], build_number: next_build_number, run_number: 1}
  end

  def next_build_number do
    query = from j in Job,
      order_by: [desc: j.build_number],
      limit: 1
    job = Repo.one(query)
    job.build_number + 1
  end

  def show(conn, params) do
    {:ok, body} = Repo.get(Job, params["id"]) |>
    JSEX.encode

    json conn, body
  end
end
