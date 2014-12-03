defmodule Pipeline.Controllers.Status do
  use Phoenix.Controller
  import Ecto.Query
  alias Models.Job
  alias Pipeline.Parser
  alias Domain.Pipeline
  alias Domain.Task

  def show(conn, params) do
    {:ok, body} = params["id"] |>
    Parser.find_by_path |>
    Results.pipeline_results |>
    JSX.encode
    json conn, body
  end
end
