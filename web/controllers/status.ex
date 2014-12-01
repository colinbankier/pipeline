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
    fetch_job_results([]) |>
    JSX.encode
    json conn, body
  end

  def fetch_job_results(pipeline = %Pipeline{}, parent_path) do
    path = append(parent_path, pipeline.name)
    job_results = Enum.map pipeline.tasks, fn(task) ->
      fetch_job_results(task, path)
    end
    %{pipeline | tasks: job_results} |> Map.put :status, "success"
  end

  def fetch_job_results(task = %Task{}, parent_path) do
    path = append(parent_path, task.name)
    query = from j in Job,
      where: j.path == array(^path, ^:string),
      order_by: [desc: j.build_number],
      limit: 1
    job = Repo.one(query)
    set_status task, job
  end

  def set_status task, nil do
    Map.put task, :status, ""
  end

  def set_status task, job do
    Map.put task, :status, job.status
  end

  def append list, item do
    List.insert_at(list, -1, item)
  end
end
