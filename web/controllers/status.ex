defmodule Pipeline.Controllers.Status do
  use Phoenix.Controller
  import Ecto.Query
  alias Models.Job
  alias Pipeline.Parser
  alias Domain.Pipeline

  def show(conn, params) do
    {:ok, body} = params["id"] |>
    Parser.find_by_path |>
    fetch_job_results |>
    JSEX.encode

    json conn, body
  end

  def fetch_job_results pipeline do
    pipeline
  end
end
