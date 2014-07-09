defmodule ProcTest do
  def listen do
    receive do
      msg ->
        process_message msg
    after 3000 ->
      IO.puts "Nothing happened as far as I am concerned"
    end
  end

  def run do
    spawn(ProcTest, :async_run, [])
  end

  def async_run do
    command = "echo 2"
    #command = "for i in 1 2 3; do sleep 1; echo \"Iter$i\"; done; exit 1;"
    {_, pid, _} = :exec.run(String.to_char_list!(command), [:stdout, :stderr, :monitor, {:cd, '/Users/colin.bankier'}])
    listen
  end
  
  def run command, working_dir do
    spawn(ProcTest, :_run, [command, working_dir])
  end

  def _run command, working_dir do
    IO.puts "Running:"
    IO.inspect command
    :exec.run(String.to_char_list!(command), [:stdout, :stderr, :monitor, {:cd, String.to_char_list!(working_dir)}])
    #:exec.run(String.to_char_list!(command), [:stdout, :stderr, :monitor, {:cd, '/Users/colin.bankier'}])
    listen
  end

  def process_message {:EXIT, pid, status} do
    IO.puts "process exited."
  end

  def process_message {source, ospid, output} do
    IO.puts output
    IO.inspect(:exec.pid(ospid))
    listen
  end

  def process_message message do
    IO.puts "Ignoring unmatched message:"
    IO.inspect message
    listen
  end

end
