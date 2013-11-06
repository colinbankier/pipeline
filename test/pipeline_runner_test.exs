import Pipeline.TestHelper

defmodule PipelineTest do
  use ExUnit.Case
  alias Models.Pipeline
  alias Models.Task
  alias Result.TaskResult
  alias Result.PipelineResult
 
  test "initializes pipeline result" do
    result = PipelineRunner.start(simple_pipeline)

    assert result == simple_initialized_pipeline_result
  end

  test "initializes sequence of tasks" do
    pipe = Pipeline.new name: "Sequence", tasks: [
      create_task("1"),
      create_task("2"),
      create_task("3")
      ]

    expected_result = PipelineResult.new name: "Sequence", tasks: [
      TaskResult.new(name: "Task 1", output: "", status: :not_started),
      TaskResult.new(name: "Task 2", output: "", status: :not_started),
      TaskResult.new(name: "Task 3", output: "", status: :not_started)
      ]
    assert PipelineRunner.start(pipe) == expected_result
  end

  test "runs sequence of tasks" do
    pipe = Pipeline.new name: "Sequence", tasks: [
      create_task("1"),
      create_task("2"),
      create_task("3")
    ]

    expected_result = PipelineResult.new name: "Sequence",
      status: :ok, 
      tasks: [
      TaskResult.new(name: "Task 1", output: "", status: :ok),
      TaskResult.new(name: "Task 2", output: "", status: :ok),
      TaskResult.new(name: "Task 3", output: "", status: :ok)
    ]
    assert PipelineRunner.run(pipe) == expected_result
  end

  test "runs nested tasks" do
    expected_result = PipelineResult.new(name: "Simple Pipeline",
    status: :ok,
    tasks: [
      TaskResult.new(name: "task 1", status: :ok,
      output: "1\n"),
      PipelineResult.new(name: "task 2",
      status: :ok,
      tasks: [
        TaskResult.new(name: "task 2a", status: :ok,
        output: "2a\n"),
        TaskResult.new(name: "task 2b", status: :ok,
        output: "2b\n"),
        TaskResult.new(name: "task 2c", status: :ok,
        output: "2c\n"),
        ]
      ),
      TaskResult.new(name: "task 3", status: :ok,
      output: "3\n")
      ]
    )
    assert PipelineRunner.run(simple_pipeline) == expected_result
  end

  test "runs mulitline command" do
    command = """
    echo 1
    echo 2
    """
    pipe = Pipeline.new name: "Multiline Pipeline", tasks:
      [ create_task(command) ]

    expected_result = PipelineResult.new(name: "Multiline Pipeline",
    status: :ok,
    tasks: [
      TaskResult.new(name: "task 1", status: :ok,
      output: "1\n2\n"),
      ]
    )
    assert PipelineRunner.run(pipe) == expected_result
  end

  test "result has ok status if exit status 0" do
    command = "exit 0"
    pipe = Pipeline.new name: "Successful Pipeline", tasks:
      [ create_task(command) ]
    expected_result = PipelineResult.new(name: "Successful Pipeline",
    status: :ok,
    tasks: [
      TaskResult.new(name: "task 1", status: :ok,
      output: ""),
      ]
    )

    assert PipelineRunner.run(pipe) == expected_result
  end

  test "result has error status if exit status 1" do
    command = "exit 1"
    pipe = Pipeline.new name: "Failed Pipeline", tasks:
      [ Task.new(name: "Error", command: "exit 1") ]
    expected_result = PipelineResult.new(name: "Failed Pipeline",
    status: :error,
    tasks: [
      TaskResult.new(name: "task 1", status: :error,
      output: ""),
      ]
    )

    assert PipelineRunner.run(pipe) == expected_result
  end

  test "result has not started status if predecessor fails" do
    pipe = Pipeline.new name: "Failed Pipeline", tasks: [
      Task.new(name: "Error", command: "exit 1"),
      Task.new(name: "Not run", command: "echo 2")
      ]

    expected_result = PipelineResult.new(name: "Failed Pipeline",
    status: :error,
    tasks: [
      TaskResult.new(name: "Error", status: :error,
      output: ""),
      TaskResult.new(name: "Not run", status: :not_started,
      output: ""),
      ]
    )

    assert PipelineRunner.run(pipe) == expected_result
  end

  def task_result(number, status // :ok) do
    TaskResult.new name: "Task " <> number, output: number <> "\n", status: status
  end
end
