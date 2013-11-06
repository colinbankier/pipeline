defmodule PipelineRunner do

  alias Models.Pipeline
  alias Models.Task
  alias Result.PipelineResult
  alias Result.TaskResult

  def start(pipe) do
    initialize(pipe)
  end

  def initialize(pipeline = Pipeline[]) do
    PipelineResult.new name: pipeline.name
  end

  def initialize(task = Task[]) do
    TaskResult.new name: task.name
  end

  def run(pipeline = Pipeline[]) do
    {_, [pipeline_result | _ ]} = _run(pipeline, {:ok, []})
    pipeline_result
  end

  def _run(pipeline = Pipeline[], { pipeline_status, result_list }) do
    {status, task_results} = Enum.reduce(pipeline.tasks, {:not_started, []}, &_run/2)
    {status, [PipelineResult.new(name: pipeline.name, status: status, tasks: task_results)]}
  end

  def _run(task = Task[], { pipeline_status, result_list }) do
    result = run_process(last_result(result_list), task.command)
    task_result = TaskResult.new(name: task.name, output: result[:output], status: result[:status])
    {overall_status(pipeline_status, result[:status]), [ task_result | result_list ] }
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
    :exec.run(String.to_char_list!(command), [:stdout, :sync])
    |> build_run_result
  end

  def run_process( _ , _) do
    [ output: nil, status: :not_started ]
  end

  def build_run_result({return_code, output}) do
    [
        output: single_string(Keyword.get(output, :stdout)),
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
