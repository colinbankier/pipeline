defmodule TaskRunner do
  alias Models.Pipeline
  alias Models.Task
  alias Result.PipelineResult
  alias Result.TaskResult

  def listen do
    receive do
      msg ->
        process_message msg
    after 9000 ->
      IO.puts "Nothing happened as far as I am concerned"
    end
  end

  def run_task path, pipeline, working_dir do
    spawn(TaskRunner, :_run, [path, pipeline, working_dir])
  end

  def run command, working_dir do
    spawn(TaskRunner, :_run, [command, working_dir])
  end

  def _run path, pipeline, working_dir do
    set_task_path(self(), path, pipeline)
    task = PipelineRunner.find path, pipeline
    IO.puts "initial output"
    IO.inspect self()
    IO.inspect lookup_task_output(self())
    :exec.run(String.to_char_list!(task.command), [:stdout, :stderr, :monitor,
      {:cd, String.to_char_list!(working_dir)}])
    listen
  end

  def _run command, working_dir do
    :exec.run(String.to_char_list!(command), [:stdout, :stderr, :monitor,
      {:cd, String.to_char_list!(working_dir)}])
    listen
  end

  def process_message {:EXIT, pid, status} do
    handle_exit pid, status
  end

  def process_message {:DOWN, _, _, pid, status} do
    handle_exit pid, status
  end

  def handle_exit pid, status do
    IO.puts "process exited."
    get_exec_status = fn
      {:exit_status, exec_status} -> exec_status
      :normal -> 0
    end
    {:status, exit_code} = :exec.status(get_exec_status.(status))
    {path, pipeline, output} = lookup_task_output(self())
    IO.puts "Exit path:"
    IO.inspect pid
    IO.inspect path
    IO.inspect pipeline
    IO.inspect output
    [ name | parent ] = Enum.reverse path
    task_result = TaskResult.new(name: name, output: output, status: status_sym_from_int(exit_code))
    PipelineRunner.notify_task_complete pipeline, path, task_result
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

  def set_task_path(pid, path, pipeline) do
    {_, _, existing_output} = lookup_task_output(pid)
    :ets.insert(:task_output, {pid, path, pipeline, existing_output})
  end

  def append_task_output(pid, output) do
    {path, pipeline, existing_output} = lookup_task_output(pid)
    :ets.insert(:task_output, {pid, path, pipeline, existing_output <> output})
  end

  def lookup_task_output(pid) do
    get_existing_output = fn
      [head = {_, path, pipeline, output} | tail] -> {path, pipeline, output}
      _ -> {[], nil, ""}
    end

    get_existing_output.(:ets.lookup(:task_output, pid))
  end

end
