import Pipeline.TestHelper

defmodule TaskRunnerTest do
  use ExUnit.Case
  alias Models.Job
  alias Pipeline.Repo
  alias Domain.Pipeline
  alias Domain.Task
  alias Result.PipelineResult
  alias Result.TaskResult

  test "Runs job from DB" do
    job = create_job(simple_pipeline_json, ["Simple Pipeline", "task 1"])

    run_job = TaskRunner.run job.id
    job = Repo.get(Job, job.id)

    assert job.status == "success"
    assert job.output == "1\n"
  end

  test "A failing job exits with output and failure status" do
    pipeline = %Pipeline{name: "Failed Pipeline", tasks:
      [ %Task{name: "Error", command: "echo exiting; exit 1"} ]
      }
    job = create_job(pipeline, ["Failed Pipeline", "Error"])

    run_job = TaskRunner.run job.id
    job = Repo.get(Job, job.id)

    assert job.status == "failed"
    assert job.output == "exiting\n"
  end

  test "Running a pipeline directly fails gracefully" do
    job = run_task(simple_pipeline_json, ["Simple Pipeline"])

    assert job.status == "failure"
    assert job.output == "You cannot execute something that is not a Task."
  end
end
