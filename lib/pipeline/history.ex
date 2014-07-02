defmodule PipelineHistory do
  alias Result.PipelineResult
  alias Result.TaskResult

  def store task=%{type: :task_result} do
    result = to_map(task) |> _insert!
    id = result[:generated_keys] |> Enum.first
    task.id(id)
  end

  def store pipeline=%{type: :pipeline_result} do
    tasks = Enum.map(pipeline.tasks, &PipelineHistory.store/1)
    result = to_map(pipeline) |> _insert!
    id = result[:generated_keys] |> Enum.first
    pipeline.id(id).tasks(tasks)
  end

  def _insert! map do
  end

  def to_map result=%{type: :task_result} do
    [
      _type: type_for(result),
      path: result.path,
      pipeline_build_number: result.pipeline_build_number,
      build_number: result.build_number,
      status: result.status,
      output: result.output
    ]
  end

  def to_map result=%{type: :pipeline_result} do
    [
      _type: type_for(result),
      path: result.path,
      pipeline_build_number: result.pipeline_build_number,
      build_number: result.build_number,
      status: result.status,
      tasks: task_list_to_map(result.tasks)
    ]
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
    # r.table("task_results").filter( path: path,
    #   pipeline_build_number: pipeline_build_number,
    #   build_number: build_number
    # ).run! |>
    # Enum.first |>
    # to_record
  end

  def get path, pipeline_build_number do
    # r.table("task_results").filter( path: path,
    #   pipeline_build_number: pipeline_build_number,
    # ).order_by(
    #   r.desc("build_number")
    # ).limit(1).run! |>
    # Enum.first |>
    # to_record
  end

  def to_record dict do
    IO.inspect dict
    cond do dict[:_type] == "task" ->
      to_task_record dict
    dict[:_type] == "pipeline" ->
      to_pipeline_record dict
    true ->
        nil
    end
  end

  def to_task_record dict do
    TaskResult.new id: dict[:id],
      path: dict[:path],
      pipeline_build_number: round(dict[:pipeline_build_number]),
      build_number: round(dict[:build_number]),
      status: binary_to_atom(dict[:status]),
      output: dict[:output]
  end

  def to_pipeline_record dict do
    pipeline_build_number = round(dict[:pipeline_build_number])
    PipelineResult.new id: dict[:id],
      path: dict[:path],
      pipeline_build_number: pipeline_build_number,
      build_number: round(dict[:build_number]),
      status: binary_to_atom(dict[:status]),
      tasks: get_tasks(dict[:tasks], pipeline_build_number)
  end

  def get_tasks task_paths, pipeline_build_number do
    Enum.map task_paths, fn path ->
      get(path, pipeline_build_number)
    end
  end

  def get pipeline do

  end
end
