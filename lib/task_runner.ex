defmodule TaskRunner do
  def listen do
    receive do
      msg ->
        process_message msg
    after 3000 ->
      IO.puts "Nothing happened as far as I am concerned"
    end
  end

  def run command do
    spawn(TaskRunner, :_run, [command])
  end

  def _run command do
    :exec.run(String.to_char_list!(command), [:stdout, :stderr, :monitor])
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
    PipelineRunner.append_task_output(self(), output)
    listen
  end

  def process_message message do
    IO.puts "Ignoring unmatched message:"
    IO.inspect message
    listen
  end
end
