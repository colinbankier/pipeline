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

  test "Running a pipeline directly fails gracefully" do
    job = run_job(simple_pipeline_json, ["Simple Pipeline"])

    assert job.status == "failure"
    assert job.output == "You cannot execute something that is not a Task."
  end

  test "result has ok status if exit status 0" do
    command = "exit 0"
    pipe = %Pipeline{name: "Successful Pipeline", tasks:
      [ %Task{name: "Task 1", command: command} ]
      }
    expected_result = %PipelineResult{id: 1, name: "Successful Pipeline",
    status: :ok,
    tasks: [
      %TaskResult{name: "Task 1", status: :ok,
      output: ""},
      ]
    }

    {:ok, build_number} = pipe |> PipelineRunner.run
    assert poll_until_complete(pipe, build_number) == expected_result
  end
end
