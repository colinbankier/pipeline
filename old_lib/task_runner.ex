defmodule TaskRunner do
  alias Models.Pipeline
  alias Models.Task
  alias Result.PipelineResult
  alias Result.TaskResult

  def listen do
    receive do
      msg ->
        process_message msg
    end
  end

  def run_task nil, _, _ do
    nil
  end

  def run_task path, pipeline, build_number, working_dir do
    spawn(TaskRunner, :_run, [path, pipeline, build_number, working_dir])
  end

  def _run path, pipeline, build_number, working_dir do
    set_task_path(self(), path, pipeline, build_number)
    task = PipelineRunner.find path, pipeline
    :exec.run(String.to_char_list(task.command), [:stdout, :stderr, :monitor,
      {:cd, String.to_char_list(working_dir)}])
    listen
  end

  def process_message {:EXIT, pid, status} do
    handle_exit pid, status
  end

  def process_message {:DOWN, _, _, pid, status} do
    handle_exit pid, status
  end

  def handle_exit pid, status do
    get_exec_status = fn
      {:exit_status, exec_status} -> exec_status
      :normal -> 0
    end
    {:status, exit_code} = :exec.status(get_exec_status.(status))
    {path, pipeline, build_number, output} = lookup_task_output(self())
    [ name | parent ] = Enum.reverse path
    task_result = %TaskResult{name: name, output: output, status: status_sym_from_int(exit_code)}
    PipelineRunner.notify_task_complete pipeline, path, build_number, task_result
  end

  def status_sym_from_int 0 do
    :ok
  end

  def status_sym_from_int _ do
    :error
  end

  def process_message {source, ospid, output} do
    IO.puts output
    append_task_output(self(), output)
    listen
  end

  def process_message message do
    IO.puts "Ignoring unmatched message:"
    IO.inspect message
    listen
  end

  def set_task_path(pid, path, pipeline, build_number) do
    {_, _, _, existing_output} = lookup_task_output(pid)
    :ets.insert(:task_output, {pid, path, pipeline, build_number, existing_output})
  end

  def append_task_output(pid, output) do
    {path, pipeline, build_number, existing_output} = lookup_task_output(pid)
    :ets.insert(:task_output, {pid, path, pipeline, build_number, existing_output <> output})
  end

  def lookup_task_output(pid) do
    get_existing_output = fn
      [head = {_, path, pipeline, build_number, output} | tail] -> {path, pipeline, build_number, output}
      _ -> {[], nil, nil, ""}
    end

    get_existing_output.(:ets.lookup(:task_output, pid))
  end

end
