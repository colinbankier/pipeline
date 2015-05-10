import Pipeline.TestHelper

defmodule TaskSchedulerTest do
  use ExUnit.Case
  alias Models.Job
  alias Pipeline.TaskScheduler
  alias Pipeline.Results.PipelineResult
  alias Pipeline.Results.TaskResult
  alias Pipeline.Results
  alias Pipeline.Repo
  alias Domain.Pipeline
  alias Domain.Task

  test "Runs entire pipeline and stores results." do
    pipeline = simple_pipeline
    job = pipeline |> TaskScheduler.trigger_build

    expected = %PipelineResult{name: "Simple Pipeline",
    status: :success,
    tasks: [
      %TaskResult{name: "task 1", output: "1\n", status: :success},
      %PipelineResult{name: "task 2",
      status: :success,
      tasks: [
        %TaskResult{name: "task 2a", output: "2a\n", status: :success },
        %TaskResult{name: "task 2b", output: "2b\n", status: :success },
        %TaskResult{name: "task 2c", output: "2c\n", status: :success },
        ]
      },
      %TaskResult{name: "task 3", output: "3\n", status: :success},
      ]
    }
    wait_for fn() ->
      Results.pipeline_status(pipeline, job.build_number) == expected
    end
    assert Results.pipeline_status(pipeline, job.build_number) == expected
  end

  test "Schedule a successful job" do
    pipeline = %Pipeline{name: "Successful Pipeline", tasks:
      [ %Task{name: "Success", command: "echo 1"} ]
      }
    job = TaskScheduler.trigger_build(pipeline)

    wait_for fn() ->
      Results.find_job(job.id).status == "success"
    end

    assert Results.find_job(job.id).output == "1\n"
  end
end
