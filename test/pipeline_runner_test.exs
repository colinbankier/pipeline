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

    expected_result = PipelineResult.new name: "Sequence", tasks: [
      TaskResult.new(name: "Task 1", output: "", status: :ok),
      TaskResult.new(name: "Task 2", output: "", status: :ok),
      TaskResult.new(name: "Task 3", output: "", status: :ok)
    ]
    assert PipelineRunner.run(pipe) == expected_result
  end

  test "runs nested tasks" do
    expected_result = [
      task_result("1\n"),
      task_result("2a\n"),
      task_result("2b\n"),
      task_result("2c\n"),
      task_result("3\n")
    ]
    assert PipelineRunner.run(simple_pipeline) == expected_result
  end

  test "runs mulitline command" do
    command = """
    echo "1"
    echo "2"
    """
    pipe = [ create_task(command) ]

    expected_result = [
        task_result("1\n2\n")
    ]
    assert PipelineRunner.run(pipe) == expected_result
  end

  test "result has ok status if exit status 0" do
    command = "exit 0"
    pipe = [ create_task(command) ]

    expected_result = [
        task_result("", :ok)
    ]
    assert PipelineRunner.run(pipe) == expected_result
  end

  test "result has error status if exit status 1" do
    command = "exit 1"
    pipe = [ create_task(command) ]

    expected_result = [
        task_result("", :error)
    ]
    assert PipelineRunner.run(pipe) == expected_result
  end

  test "result has not started status if predecessor fails" do
    pipe = [
      create_task("exit 1"),
      create_task("echo \"3\"")
    ]

    expected_result = [
      task_result("", :error),
      task_result(nil, :not_started )
    ]
    assert PipelineRunner.run(pipe) == expected_result
  end

  def task_result(number, status // :ok) do
    TaskResult.new name: "Task " <> number, output: number <> "\n", status: status
  end
end
