defmodule TaskRunner do
  alias Models.Job
  alias Domain.Pipeline

  def run job_id do
    job = Repo.get(Job, job_id)
    job = %{job | status: "running", output: ""}
    :ok = Repo.update(job)
    # spawn(__MODULE__, :_run, [job])
    _run job
  end

  def listen job do
    receive do
      msg ->
        process_message job, msg
    end
    job
  end

  def _run job do
    working_dir = "/"
    {:ok, pipeline} = Pipeline.from_json job.pipeline_json
    task = Pipeline.find(job.path, pipeline)
    :exec.run(String.to_char_list(task.command), [:stdout, :stderr, :monitor,
      {:cd, String.to_char_list(working_dir)}])
    listen job
    job
  end

  def process_message job, {:EXIT, pid, status} do
    handle_exit job, pid, status
  end

  def process_message job, {:DOWN, _, _, pid, status} do
    handle_exit job, pid, status
  end

  def handle_exit job, pid, status do
    IO.puts "handle exit"
    IO.inspect job
    get_exec_status = fn
      {:exit_status, exec_status} -> exec_status
      :normal -> 0
    end
    {:status, exit_code} = :exec.status(get_exec_status.(status))
    job = %{job | status: "success"}
    :ok = Repo.update(job)
    job
  end

  def status_sym_from_int 0 do
    :ok
  end

  def status_sym_from_int _ do
    :error
  end

  def process_message job, {source, ospid, output} do
    IO.puts "Got output"
    IO.puts output
    job = %{ job | output: job.output <> output}
    listen job
  end

  def process_message job, message do
    IO.puts "Ignoring unmatched message:"
    IO.inspect message
    listen job
  end
end
