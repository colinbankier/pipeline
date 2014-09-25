defmodule Pipeline.Controllers.Jobs do
  use Phoenix.Controller
  alias Models.Job
  alias Pipeline.Parser

  def create(conn, params) do
    {:ok, body} = params["source_repo"] |>
    Parser.find_by_path |>
    TaskScheduler.trigger_task([]) |>
    JSEX.encode

    json conn, body
  end

  def show(conn, params) do
    {:ok, body} = Repo.get(Job, params["id"]) |>
    JSEX.encode

    json conn, body
  end
end
