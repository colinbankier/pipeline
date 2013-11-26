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

  def update(state = PipelineResult[]) do
    :ets.insert(:pipeline_results, state)
  end

  def current_state() do
    :ets.lookup(:pipeline_results, 1) |> Enum.first
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

  def append_task_output(pid, output) do
    :ets.insert(:task_output, {pid, lookup_task_output(pid) <> output})
  end

  def lookup_task_output(pid) do
    get_existing_output = fn
      [head = {_, output} | tail] -> output
      _ -> ""
    end

    get_existing_output.(:ets.lookup(:task_output, pid))
  end

  def run_process(:ok, command) do
    working_dir = PipelineApp.default_working_dir |> String.to_char_list!
    :exec.run(String.to_char_list!(command), [:stdout, :stderr, {:cd, working_dir}])
    #|> build_run_result
    [ output: "", status: :started ]
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
