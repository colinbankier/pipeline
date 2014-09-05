defmodule Pipeline.Controllers.Jobs do
  use Phoenix.Controller
  import Ecto.Query
  alias Models.Job
  alias Pipeline.Parser
  alias Domain.Pipeline

  def create(conn, params) do
    {:ok, body} = params["source_repo"] |>
    Parser.find_by_path |>
    create_job |>
    Repo.insert |>
    schedule_job |>
    JSEX.encode

    json conn, body
  end

  def schedule_job job do
    {:ok, pid} = ElixirTalk.connect()
    ElixirTalk.put(pid, to_string(job.id))
    job
  end

  def create_job task do
    path = [task.name]
    subtask_path = Pipeline.find_sub_task path, task

    {:ok, pipeline_json} = JSEX.encode task
    %Job{
      path: subtask_path,
      status: "scheduled",
      build_number: next_build_number,
      run_number: 1,
      pipeline_json: pipeline_json
    }
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
