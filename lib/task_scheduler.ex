defmodule TaskScheduler do
  import Ecto.Query
  alias Models.Job
  alias Pipeline.Parser
  alias Domain.Pipeline

  def trigger_task pipeline, path do
    pipeline |>
    create_job(path) |>
    Repo.insert |>
    schedule_job
  end

  def schedule_job job do
    {:ok, pid} = ElixirTalk.connect()
    ElixirTalk.put(pid, to_string(job.id))
    job
  end

  def create_job pipeline, [] do
    create_job pipeline, [pipeline.name]
  end

  def create_job pipeline, path do
    IO.puts "Creating next job #{path}"
    subtask_path = Pipeline.find_sub_task path, pipeline
    IO.puts "Creating job #{subtask_path}"

    {:ok, pipeline_json} = JSX.encode pipeline
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
    Repo.one(query) |> next_build_number
  end

  def next_build_number nil do
    1
  end

  def next_build_number job = %Job{} do
    job.build_number + 1
  end
end
