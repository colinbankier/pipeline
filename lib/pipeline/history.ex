defmodule PipelineHistory do
  import Ecto.Query, only: [from: 2]
  alias Result.PipelineResult
  alias Result.TaskResult
  alias Result.RunResult

  def store task=%{type: :task_result} do
    result = to_map(task) |> _insert!
    result
  end

  def store pipeline=%{type: :pipeline_result} do
    tasks = Enum.map(pipeline.tasks, &PipelineHistory.store/1)
    result = to_map(pipeline) |> _insert!
    result
  end

  def _insert! map do
    Repo.insert(map) |> to_record
  end

  def to_map result=%{type: :task_result} do
    %RunResult{
      type: to_string(result.type),
      path: result.path,
      pipeline_build_number: result.pipeline_build_number,
      build_number: result.build_number,
      status: to_string(result.status),
      output: result.output
    }
  end

  def to_map result=%{type: :pipeline_result} do
    %RunResult{
      type: to_string(result.type),
      path: result.path,
      pipeline_build_number: result.pipeline_build_number,
      build_number: result.build_number,
      status: to_string(result.status),
      #tasks: task_list_to_map(result.tasks)
    }
  end

  def task_list_to_map tasks do
    Enum.map(tasks, fn task -> task.path end)
  end

  def type_for result=%{type: :pipeline_result} do
    "pipeline"
  end

  def type_for result=%{type: :task_result} do
    "task"
  end

  def get path, pipeline_build_number, build_number do
    query = from r in RunResult,
      where: r.path == array(^path, ^:string) and
      r.pipeline_build_number == ^pipeline_build_number and
      r.build_number == ^build_number,
      order_by: [desc: r.build_number],
      limit: 1

    Repo.one(query) |> to_record
    # r.table("task_results").filter( path: path,
    #   pipeline_build_number: pipeline_build_number,
    #   build_number: build_number
    # ).run! |>
    # Enum.first |>
    # to_record
  end

  def get path, pipeline_build_number do
    query = from r in RunResult,
      where: r.path == array(^path, ^:string) and
      r.pipeline_build_number == ^pipeline_build_number,
      order_by: [desc: r.build_number],
      limit: 1

    Repo.one(query) |> to_record

    # r.table("task_results").filter( path: path,
    #   pipeline_build_number: pipeline_build_number,
    # ).order_by(
    #   r.desc("build_number")
    # ).limit(1).run! |>
    # Enum.first |>
    # to_record
  end

  def to_record(dict = %RunResult{type: "task_result"}) do
    %TaskResult{id: dict.id,
      path: dict.path,
      pipeline_build_number: round(dict.pipeline_build_number),
      build_number: round(dict.build_number),
      status: binary_to_atom(dict.status),
      output: dict.output
      }
  end

  def to_record(dict = %RunResult{type: "pipeline_result"}) do
    %PipelineResult{id: dict.id,
      path: dict.path,
      pipeline_build_number: dict.pipeline_build_number,
      build_number: dict.build_number,
      status: binary_to_atom(dict.status),
      #tasks: get_tasks(dict.tasks, dict.pipeline_build_number)
      }
  end

  def get_tasks task_paths, pipeline_build_number do
    Enum.map task_paths, fn path ->
      get(path, pipeline_build_number)
    end
  end

  def get pipeline do
    path = [pipeline.name]
    query = from r in RunResult,
      where: r.path == array(^path, ^:string),
      order_by: [asc: r.build_number]

    Enum.map Repo.all(query), &to_record/1
  end
end
