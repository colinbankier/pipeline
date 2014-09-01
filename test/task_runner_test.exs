import Pipeline.TestHelper

defmodule TaskRunnerTest do
  use ExUnit.Case

  test "Runs job from DB" do
    job = create_job(simple_pipeline_json, ["Simple Pipeline", "task 1"])

    run_job = TaskRunner.run job.id

    assert run_job.status == "success"
    assert run_job.output == "1\n"
  end
end
