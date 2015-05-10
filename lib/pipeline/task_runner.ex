defmodule TaskRunner do
  import Ecto.Model
  alias Models.Job
  alias Models.Build
  alias Pipeline.Repo
  alias Pipeline.TaskScheduler
  alias Domain.Pipeline
  alias Domain.Task

  def run job_id do
    Repo.get(Job, job_id) |> initialise_job |> _run
  end

  def initialise_job job do
    IO.puts "Init job run #{job.name}: #{job.path}"
    %{job | status: "running", output: ""}
    |> Repo.update
  end

  def listen job do
    receive do
      msg ->
        process_message job, msg
    end
  end

  def _run job do
    working_dir = "/"
    {:ok, task} = Task.from_json job.task_json
    completed_job = task |> _exec(job, working_dir)

    build = Repo.one assoc(job, :build)

    {:ok, pipeline} = Pipeline.from_json build.pipeline_json
    trigger_next completed_job, pipeline
  end

  def trigger_next(job, pipeline) do
    if job.status == "success" do
      next_path = Pipeline.find_next_task job.path, pipeline
      IO.puts "trigger next #{next_path}"
      trigger_next_path pipeline, next_path, job.build_number
    else
      IO.puts "skipping trigger"
    end
  end

  def trigger_next_path pipeline, nil, _ do
   IO.puts "End of pipeline"
  end

  def trigger_next_path pipeline, path, build_number do
    TaskScheduler.trigger_task(pipeline, path, build_number)
  end

  def _exec task = %Task{}, job, working_dir do
    IO.puts "exec #{task.name}"
    :exec.run(String.to_char_list(task.command), [:stdout, :stderr, :monitor,
      {:cd, String.to_char_list(working_dir)}])
    listen job
  end

  def _exec _, job , _ do
    msg = "You cannot execute something that is not a Task."
    %{job | status: "failure", output: msg}
    |> Repo.update
  end

  def process_message job, {:EXIT, pid, status} do
    handle_exit job, pid, status
  end

  def process_message job, {:DOWN, _, _, pid, status} do
    handle_exit job, pid, status
  end

  def process_message job, {source, ospid, output} do
    job = %{ job | output: job.output <> output}
    listen job
  end

  def process_message job, message do
    IO.puts "Ignoring unmatched message:"
    IO.inspect message
    listen job
  end

  def handle_exit job, pid, status do
    get_exec_status = fn
      {:exit_status, exec_status} -> exec_status
      :normal -> 0
    end
    {:status, exit_code} = :exec.status(get_exec_status.(status))
    %{job | status: status_from_int(exit_code)}
    |> Repo.update
  end

  def status_from_int 0 do
    to_string :success
  end

  def status_from_int _ do
    to_string :failed
  end
end
