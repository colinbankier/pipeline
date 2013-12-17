Dynamo.under_test(PipelineApp.Dynamo)
Dynamo.Loader.enable
ExUnit.start

defmodule Pipeline.TestCase do
  use ExUnit.CaseTemplate

  # Enable code reloading on test cases
  setup do
    Dynamo.Loader.enable
    :ok
  end
end

defmodule Pipeline.TestHelper do
  alias Models.Pipeline
  alias Models.Task
  alias Result.PipelineResult
  alias Result.TaskResult

  def simple_pipeline_json do
     """
    { "name": "Simple Pipeline",
    "tasks": [
    { "name": "task 1", "command": "echo 1" },
    { "name": "task 2",
    "tasks": [
    { "name": "task 2a", "command": "echo 2a" },
    { "name": "task 2b", "command": "echo 2b" },
    { "name": "task 2c", "command": "echo 2c" }
    ]
    },
    { "name": "task 3", "command": "echo 3" }
    ]
    }
    """
  end

  def simple_pipeline do
    Pipeline.new(name: "Simple Pipeline",
    tasks: [
      Task.new(name: "task 1", command: "echo 1"),
      Pipeline.new(name: "task 2",
      tasks: [
        Task.new(name: "task 2a", command: "echo 2a" ),
        Task.new(name: "task 2b", command: "echo 2b" ),
        Task.new(name: "task 2c", command: "echo 2c" ),
        ]
      ),
      Task.new(name: "task 3", command: "echo 3"),
      ]
    )
  end

  def simple_initialized_pipeline_result do
    PipelineResult.new(id: 1, path: ["Simple Pipeline"],
    status: :not_started,
    pipeline_build_number: 1,
    build_number: 1,
    tasks: [
      TaskResult.new(path: ["Simple Pipeline", "task 1"], status: :not_started,
      pipeline_build_number: 1,
      build_number: 1,
      output: ""),
      PipelineResult.new(id: 1, path: ["Simple Pipeline", "task 2"],
      pipeline_build_number: 1,
      build_number: 1,
      status: :not_started,
      tasks: [
        TaskResult.new(path: ["Simple Pipeline", "task 2", "task 2a"], status: :not_started,
        pipeline_build_number: 1,
        build_number: 1,
        output: ""),
        TaskResult.new(path: ["Simple Pipeline", "task 2", "task 2b"], status: :not_started,
        pipeline_build_number: 1,
        build_number: 1,
        output: ""),
        TaskResult.new(path: ["Simple Pipeline", "task 2", "task 2c"], status: :not_started,
        pipeline_build_number: 1,
        build_number: 1,
        output: ""),
        ]
      ),
      TaskResult.new(path: ["Simple Pipeline", "task 3"], status: :not_started,
      pipeline_build_number: 1,
      build_number: 1,
      output: "")
      ]
    )
  end

  def create_task(number) do
    Task.new name: "Task " <> number, command: "echo " <> number
  end
end
