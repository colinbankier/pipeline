import Pipeline.TestHelper

defmodule TaskRunnerTest do
  use ExUnit.Case
  alias Models.Job

  test "Runs job from DB" do
    job = create_job(simple_pipeline_json, ["Simple Pipeline", "task 1"])

    run_job = TaskRunner.run job.id
    job = Repo.get(Job, job.id)

    assert job.status == "success"
    assert job.output == "1\n"
    assert job.status == run_job.status
    assert job.output == run_job.output
  end

  test "Running a pipeline runs the first task" do
    job = create_job(simple_pipeline_json, ["Simple Pipeline"])

    TaskRunner.run job.id
    job = Repo.get(Job, job.id)

    assert job.status == "success"
    assert job.output == "1\n"
  end
end
