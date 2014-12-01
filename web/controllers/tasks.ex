defmodule Pipeline.Controllers.Tasks do
  use Phoenix.Controller
  alias Pipeline.Models.Pipeline

  def create(conn, params) do
    IO.inspect params
    pipeline_id = String.to_integer(params["pipeline_id"])
    task = %Pipeline{
      name: params["name"],
      command: params["command"],
      pipeline_id: pipeline_id
    }
    task = Repo.insert task
    {:ok, body} = JSX.encode task

    json conn, body
  end

  def show(conn, params) do
    IO.inspect params
    task = Pipeline.find(String.to_integer(params["id"]))
    {:ok, body} = JSX.encode task
    json conn, body
  end
end
