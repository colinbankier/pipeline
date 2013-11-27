defmodule TaskRunner do
  def listen do
    receive do
      msg ->
        process_message msg
    after 3000 ->
      IO.puts "Nothing happened as far as I am concerned"
    end
  end

  def run command, working_dir do
    spawn(TaskRunner, :_run, [command, working_dir])
  end

  def _run command, working_dir do
    :exec.run(String.to_char_list!(command), [:stdout, :stderr, :monitor, {:cd, working_dir}])
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
    IO.inspect :exec.status(get_exec_status.(status))
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

end
