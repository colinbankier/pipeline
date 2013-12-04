defmodule PipelineRunner do

  alias Models.Pipeline
  alias Models.Task
  alias Result.PipelineResult
  alias Result.TaskResult

  def start(pipe) do
    initialize(pipe)
  end

  def initialize(pipeline = Pipeline[]) do
    tasks = Enum.map(pipeline.tasks, &initialize/1)
    PipelineResult.new id: 1, name: pipeline.name, tasks: tasks
  end

  def initialize(task = Task[]) do
    TaskResult.new name: task.name
  end

  def run(pipeline = Pipeline[]) do
    pipeline |> initialize |> update
    {_, [pipeline_result | _ ]} = _run(pipeline, {:ok, []})
    pipeline_result |> update
    pipeline_result
  end

  def _run(pipeline = Pipeline[], { pipeline_status, result_list }) do
    {status, task_results} = Enum.reduce(pipeline.tasks, {:not_started, []}, &_run/2)
    {status, [PipelineResult.new(id: 1, name: pipeline.name, status: status, tasks: Enum.reverse(task_results)) | result_list]}
  end

  def _run(task = Task[], { pipeline_status, result_list }) do
    result = run_process(last_result(result_list), task.command)
    task_result = TaskResult.new(name: task.name, output: result[:output], status: result[:status])
    {overall_status(pipeline_status, result[:status]), [ task_result | result_list ] }
  end

  def find_next_task [ head ], pipeline do
    nil
  end

  def find_next_task path, pipeline do
    IO.inspect path
    [ head | tail ] = path |> Enum.reverse
    parent = find(Enum.reverse(tail), pipeline)
    index = Enum.find_index parent.tasks, fn task ->
      task.name == head
    end
    if index + 1 >= Enum.count(parent.tasks) do
      find_next_task(Enum.reverse(tail), pipeline)
    else
      find_sub_task(tail, Enum.at(parent.tasks, index + 1))
      |> Enum.reverse
    end
  end

  def find_sub_task(path, task = Task[]) do
    [task.name | path]
  end

  def find_sub_task(path, pipeline = Pipeline[]) do
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

  def update(state = PipelineResult[]) do
    :ets.insert(:pipeline_results, state)
  end

  def current_state() do
    :ets.lookup(:pipeline_results, 1) |> Enum.first
  end

  def lookup_current_state(pipeline_result = PipelineResult[]) do
    {status, task_results} = Enum.reduce(pipeline_result.tasks, &lookup_current_state/1)
    {status, [PipelineResult.new(id: 1, name: pipeline_result.name, status: status, tasks: Enum.reverse(task_results)) ]}
  end

  def lookup_current_state(task_result = TaskResult[]) do
    result = TaskRunner.lookup_task_output(task_result.pid)
    task_result = TaskResult.new(name: task_result.name, output: result[:output], status: result[:status])
    {overall_status(:none, result[:status]), [ task_result ] }
  end

  def notify_task_complete pipeline, path, task_result do
    update_pipeline_result(pipeline, path, task_result) |> update
    TaskRunner.run_task(find_next_task(path, pipeline), pipeline, PipelineApp.default_working_dir)
  end

  def update_pipeline_result(_, [ head | [] ], task_result) do
    task_result
  end

  def update_pipeline_result(pipeline_result, [ head | tail ], task_result) do
    pipeline_result.tasks(update_task_result(pipeline_result.tasks, tail, task_result))
  end

  def update_task_result(tasks, path = [ head | tail ], task_result) do
    index = Enum.find_index tasks, fn task ->
      task.name == head
    end
    List.replace_at(tasks, index, update_pipeline_result(Enum.at(tasks, index), path, task_result))
  end

  def overall_status(current_status, task_status) do
    switch_status = fn
      :error, :not_started -> :error
      _, task_status -> task_status
    end

    switch_status.(current_status, task_status)
  end

  def last_result(result_list = [ last_result = head | tail ]) do
    last_result.status
  end

  def last_result([]) do
    :ok
  end

  def run_process(:ok, command) do
    working_dir = PipelineApp.default_working_dir |> String.to_char_list!
    pid = TaskRunner.run command, working_dir
    [ output: "", status: :running, pid: pid ]
  end

  def run_process( _ , _) do
    [ output: "", status: :not_started ]
  end

  def build_run_result({return_code, output}) do
    [
        output: single_string(Keyword.get(output, :stdout)) <> single_string(Keyword.get(output, :stderr)),
        status: return_code
    ]
  end

  def single_string(nil) do
    ""
  end

  def single_string(output_list) do
    Enum.reduce(output_list, "", &(&2 <> &1))
  end
end
