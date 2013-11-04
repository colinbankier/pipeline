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
    _run(pipeline)
  end

  def old_run(pipe) do

    build_result_list = fn 
      (task, result_list = [ last_result = head | tail ]) ->
        result = run_process(Keyword.get(last_result, :status), task.command)
        [ result | result_list ]
      (task, result_list = []) ->
        result = run_process(:ok, task.command)
        [ result | result_list ]
    end

    pipe 
    |> List.flatten
    |> Enum.reduce([], build_result_list)
    |> Enum.reverse
  end

  def _run(pipeline = Pipeline[]) do
    task_results = Enum.map pipeline.tasks, &(_run(&1))
    PipelineResult.new(name: pipeline.name, tasks: task_results)
  end

  def _run(task = Task[]) do
    output = run_process(:ok, task.command)
    TaskResult.new name: task.name, output: output
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
