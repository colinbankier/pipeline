import Pipeline.TestHelper

defmodule TaskRunnerTest do
  use ExUnit.Case
  import Poll
  alias Models.Job
  alias Domain.Pipeline
  alias Domain.Task
  alias Result.PipelineResult
  alias Result.TaskResult

  test "Runs job from DB" do
    job = create_job(simple_pipeline_json, ["Simple Pipeline", "task 1"])

    run_job = TaskRunner.run job.id
    :timer.sleep 1000
    job = Repo.get(Job, job.id)
    IO.inspect job

    assert job.status == "success"
    assert job.output == "1\n"
  end

  test "Running a pipeline directly fails gracefully" do
    job = run_task(simple_pipeline_json, ["Simple Pipeline"])

    assert job.status == "failure"
    assert job.output == "You cannot execute something that is not a Task."
  end
end
