import Pipeline.TestHelper

defmodule ParsePipelineTest do
  use ExUnit.Case
  alias Models.Task
  alias Models.Pipeline

  test "Parse pipeline from JSON string" do

    json = """
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
    { _, pipeline} = PipelineParser.parse(json)

    expected_pipeline = Pipeline.new(name: "Simple Pipeline",
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

    assert pipeline == expected_pipeline
  end
end
