defmodule Pipeline.TaskScheduler do
  import Ecto.Query
  alias Models.Job
  alias Pipeline.Repo
  alias Pipeline.Parser
  alias Domain.Pipeline

  def trigger_build pipeline do
    build_number = next_build_number(pipeline.name)
    trigger_task pipeline, [], build_number
  end

  def trigger_task pipeline, path, build_number do
    pipeline |>
    create_job(path, build_number) |>
    Repo.insert |>
    schedule_job
  end

  def schedule_job job do
    TaskRunner.run job.id
    job
  end

  def create_job pipeline, [], build_number do
    create_job pipeline, [pipeline.name], build_number
  end

  def create_job pipeline, path, build_number do
    IO.puts "Creating next job #{path}"
    subtask_path = Pipeline.find_sub_task path, pipeline
    IO.puts "Creating job #{subtask_path}"

    {:ok, pipeline_json} = JSX.encode pipeline
    %Job{
      name: List.last(subtask_path),
      path: subtask_path,
      status: "scheduled",
      build_number: build_number,
      run_number: 1,
      pipeline_json: pipeline_json
    }
  end

  def next_build_number(pipeline_name) do
    query = from j in Job,
      where: fragment("?[1] = ?", j.path, ^pipeline_name),
      order_by: [desc: j.build_number],
      limit: 1
    Repo.one(query) |> inc_build_number
  end

  def inc_build_number nil do
    1
  end

  def inc_build_number job = %Job{} do
    job.build_number + 1
  end
end
