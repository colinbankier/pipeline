defmodule Pipeline.Controllers.Tasks do
  use Phoenix.Controller
  alias Pipeline.Models.Pipeline

  def create(conn, params) do
    IO.inspect params
    pipeline_id = String.to_integer(params["pipeline_id"])
    task = %Pipeline{name: params["name"], pipeline_id: pipeline_id}
    task = Repo.insert task
    {:ok, body} = JSEX.encode task

    json conn, body
  end
end
