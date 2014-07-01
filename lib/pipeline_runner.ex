defmodule PipelineRunner do
  alias Models.Pipeline
  alias Models.Task
  alias Result.PipelineResult
  alias Result.TaskResult

  def initialize(pipeline = %{type: :pipeline}) do
    tasks = Enum.map(pipeline.tasks, &initialize/1)
    %PipelineResult{id: 1, name: pipeline.name, tasks: tasks}
  end

  def initialize(task = %{type: :task}) do
    %TaskResult{name: task.name}
  end

  def run(pipeline = %{type: :pipeline}) do
    trigger [pipeline.name], pipeline
  end

  def trigger(nil, pipeline) do
    nil
  end

  def trigger(path, pipeline) do
    build_number = BuildNumber.next! [pipeline.name]
    _trigger(path, find(path, pipeline), pipeline, build_number)
    {:ok, build_number}
  end

  def _trigger(path, task = %{type: :task}, pipeline, build_number) do
    update_current_task_status path, :running, pipeline, build_number
    TaskRunner.run_task(path, pipeline, build_number, PipelineApp.default_working_dir)
  end

  def _trigger(path, task = %{type: :pipeline}, pipeline, build_number) do
    update_current_task_status path, :running, pipeline, build_number
    first_child = Enum.first(task.tasks)
    child_path = List.insert_at(path, Enum.count(path), first_child.name)
    _trigger(child_path, find(child_path, pipeline), pipeline, build_number)
  end

  def update_current_task_status(path, status, pipeline, build_number) do
    current_result = current_state(pipeline, build_number)
    task_result = find path, current_result
    new_result = update_pipeline_result current_result, path, task_result.status(status)
    new_result |> update(build_number)
  end

  def find_next_task [ head ], pipeline do
    nil
  end

  def find_next_task path, pipeline do
    [ head | tail ] = path |> Enum.reverse
    parent_path = Enum.reverse(tail)
    parent = find(parent_path, pipeline)
    index = Enum.find_index parent.tasks, fn task ->
      task.name == head
    end
    if index + 1 >= Enum.count(parent.tasks) do
      find_next_task(parent_path, pipeline)
    else
      task = Enum.at(parent.tasks, index + 1)
      reversed_path = [task.name | tail]
      reversed_path |> Enum.reverse
    end
  end

  def find_sub_task(path, task = %{type: :task}) do
    [task.name | path]
  end

  def find_sub_task(path, pipeline = %{type: :pipeline}) do
    task = pipeline.tasks |> Enum.first
    find_sub_task([pipeline.name | path], task)
  end

  def find([ head | [] ], pipeline) do
    if head == pipeline.name do
      pipeline
    else
     nil
    end
  end

  def find([ head | tail ], pipeline) when is_tuple(pipeline) do
    if head == pipeline.name do
      [ next | rest ] = tail
      task = Enum.find(pipeline.tasks, fn(task) ->
        task.name == next
      end)
      find(tail, task)
    else
      nil
    end
  end

  def find(path, task) do
    nil
  end

  def update(state = %{type: :pipeline_result}, build_number) do
    :ets.insert(:pipeline_results, { {state.name, build_number}, state})
  end

  def current_state(pipeline, build_number) do
    find_or_init = fn
      nil -> initialize(pipeline)
      {_, result} -> result
      result ->
        nil
    end
    find_or_init.(:ets.lookup(:pipeline_results, {pipeline.name, build_number}) |> Enum.first)
  end

  def notify_task_complete pipeline, path, build_number, task_result do
    update_pipeline_result(current_state(pipeline, build_number), path, task_result) |> update(build_number)
    if task_result.status == :ok do
      path = find_next_task(path, pipeline)
      _trigger(path, find(path, pipeline), pipeline, build_number)
    end
  end

  def update_pipeline_result(_, [ head | [] ], task_result) do
    task_result
  end

  def update_pipeline_result(pipeline_result, [ head | tail ], task_result) do
    updated_tasks = update_task_result(pipeline_result.tasks, tail, task_result)
    pipeline_result.tasks(updated_tasks).status(task_result.status)
  end

  def update_task_result(tasks, path = [ head | tail ], task_result) do
    index = Enum.find_index tasks, fn task ->
      task.name == head
    end
    List.replace_at(tasks, index, update_pipeline_result(Enum.at(tasks, index), path, task_result))
  end
end
