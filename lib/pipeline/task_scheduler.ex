defmodule Pipeline.TaskScheduler do
  import Ecto.Query
  alias Models.Job
  alias Models.Build
  alias Pipeline.Repo
  alias Pipeline.Parser
  alias Pipeline.Results
  alias Domain.Pipeline

  def trigger_build pipeline do
    pipeline
    |> create_build
    |> schedule_build pipeline, []
  end

  def trigger_task pipeline, path, build_number do
    Build.for_pipeline_build(pipeline.name, build_number)
    |> schedule_build pipeline, path
  end

  def schedule_build build, pipeline, path do
    pipeline |>
    create_job(path, build) |>
    Repo.insert |>
    schedule_job
  end

  def schedule_job job do
    TaskRunner.run job.id
    job
  end

  def create_build pipeline do
    {:ok, pipeline_json} = JSX.encode pipeline
    %Build{
      pipeline_name: pipeline.name,
      pipeline_json: pipeline_json,
      build_number: next_build_number(pipeline.name)
    }
    |> Repo.insert
  end

  def create_job pipeline, [], build do
    create_job pipeline, [pipeline.name], build
  end

  def create_job pipeline, path, build do
    IO.puts "Creating next job #{path}"
    subtask_path = Pipeline.find_sub_task path, pipeline
    IO.puts "Creating job #{subtask_path}"

    {:ok, task_json} = path
    |> Pipeline.find(pipeline)
    |> JSX.encode

    %Job{
      name: List.last(subtask_path),
      path: subtask_path,
      status: "scheduled",
      build_id: build.id,
      run_number: next_run_number(subtask_path),
      task_json: task_json
    }
  end

  def next_build_number(pipeline_name) do
    pipeline_name |> Results.latest_build_number |> inc
  end

  def next_run_number(path) do
    path |> Results.latest_run_number |> inc
  end

  def inc nil do 1 end
  def inc number do number + 1 end
end
