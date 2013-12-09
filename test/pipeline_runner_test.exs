import Pipeline.TestHelper
import Poll

defmodule PipelineTest do
  use ExUnit.Case
  alias Models.Pipeline
  alias Models.Task
  alias Result.TaskResult
  alias Result.PipelineResult

  setup do
    :ets.delete_all_objects :pipeline_results
    :ok
  end
 
  test "initializes pipeline result" do
    result = PipelineRunner.initialize(simple_pipeline)

    assert result == simple_initialized_pipeline_result
  end

  test "initializes sequence of tasks" do
    pipe = Pipeline.new name: "Sequence", tasks: [
      create_task("1"),
      create_task("2"),
      create_task("3")
      ]

    expected_result = PipelineResult.new id: 1, name: "Sequence", tasks: [
      TaskResult.new(name: "Task 1", output: "", status: :not_started),
      TaskResult.new(name: "Task 2", output: "", status: :not_started),
      TaskResult.new(name: "Task 3", output: "", status: :not_started)
      ]
    assert PipelineRunner.initialize(pipe) == expected_result
  end

  test "runs sequence of tasks" do
    pipe = Pipeline.new name: "Sequence", tasks: [
      create_task("1"),
      create_task("2"),
      create_task("3")
    ]

    expected_result = PipelineResult.new id: 1, name: "Sequence",
      status: :ok, 
      tasks: [
      TaskResult.new(name: "Task 1", output: "1\n", status: :ok),
      TaskResult.new(name: "Task 2", output: "2\n", status: :ok),
      TaskResult.new(name: "Task 3", output: "3\n", status: :ok)
    ]
    pipe |> PipelineRunner.run
    assert poll_until_complete(pipe) == expected_result
  end

  test "runs nested tasks" do
    expected_result = PipelineResult.new(id: 1, name: "Simple Pipeline",
    status: :ok,
    tasks: [
      TaskResult.new(name: "task 1", status: :ok,
      output: "1\n"),
      PipelineResult.new(id: 1, name: "task 2",
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
    simple_pipeline |> PipelineRunner.run
    assert poll_until_complete(simple_pipeline) == expected_result
  end

  test "runs mulitline command" do
    command = """
    echo 1
    echo 2
    """
    pipe = Pipeline.new name: "Multiline Pipeline", tasks:
      [ Task.new name: "Task 1", command: command ]

    expected_result = PipelineResult.new(id: 1, name: "Multiline Pipeline",
    status: :ok,
    tasks: [
      TaskResult.new(name: "Task 1", status: :ok,
      output: "1\n2\n"),
      ]
    )
    pipe |> PipelineRunner.run
    assert poll_until_complete(pipe) == expected_result
  end

  test "result has ok status if exit status 0" do
    command = "exit 0"
    pipe = Pipeline.new name: "Successful Pipeline", tasks:
      [ Task.new name: "Task 1", command: command ]
    expected_result = PipelineResult.new(id: 1, name: "Successful Pipeline",
    status: :ok,
    tasks: [
      TaskResult.new(name: "Task 1", status: :ok,
      output: ""),
      ]
    )

    pipe |> PipelineRunner.run
    assert poll_until_complete(pipe) == expected_result
  end

  test "result has error status if exit status 1" do
    command = "exit 1"
    pipe = Pipeline.new name: "Failed Pipeline", tasks:
      [ Task.new(name: "Error", command: "exit 1") ]
    expected_result = PipelineResult.new(id: 1, name: "Failed Pipeline",
    status: :error,
    tasks: [
      TaskResult.new(name: "Error", status: :error,
      output: ""),
      ]
    )

    pipe |> PipelineRunner.run
    assert poll_until_complete(pipe) == expected_result
  end

  test "should capture stderr" do
    pipe = Pipeline.new name: "Failed Pipeline", tasks: [
      Task.new(name: "Error", command: "echo foo; echo bar 1>&2; exit 1")
      ]

    expected_result = PipelineResult.new(id: 1, name: "Failed Pipeline",
    status: :error,
    tasks: [
      TaskResult.new(name: "Error", status: :error,
      output: "foo\nbar\n"),
      ]
    )

    pipe |> PipelineRunner.run
    assert poll_until_complete(pipe) == expected_result
  end

  test "working directory defaults to .pipeline" do
    pipe = Pipeline.new name: "Working Dir", tasks: [
      Task.new(name: "Working Dir", command: "pwd" )
      ]

    pipe |> PipelineRunner.run
    pipeline_result = poll_until_complete(pipe)

    output = Enum.first(pipeline_result.tasks).output
    assert output == Path.join(System.get_env("HOME"), ".pipeline") <> "\n"
  end

  test "result has not started status if predecessor fails" do
    pipe = Pipeline.new name: "Failed Pipeline", tasks: [
      Task.new(name: "Error", command: "exit 1"),
      Task.new(name: "Not run", command: "echo 2")
      ]

    expected_result = PipelineResult.new(id: 1, name: "Failed Pipeline",
    status: :error,
    tasks: [
      TaskResult.new(name: "Error", status: :error,
      output: ""),
      TaskResult.new(name: "Not run", status: :not_started,
      output: ""),
      ]
    )

    pipe |> PipelineRunner.run
    assert poll_until_complete(pipe) == expected_result
  end
end
