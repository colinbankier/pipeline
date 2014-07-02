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
    BuildNumber.clear_all
    :ok
  end
 
  test "initializes pipeline result" do
    result = PipelineRunner.initialize(simple_pipeline)

    assert result == simple_initialized_pipeline_result
  end

  test "initializes sequence of tasks" do
    pipe = %Pipeline{name: "Sequence", tasks: [
      create_task("1"),
      create_task("2"),
      create_task("3")
      ]
    }

    expected_result = %PipelineResult{id: 1, name: "Sequence", tasks: [
      %TaskResult{name: "Task 1", output: "", status: :not_started},
      %TaskResult{name: "Task 2", output: "", status: :not_started},
      %TaskResult{name: "Task 3", output: "", status: :not_started}
      ]
    }
    assert PipelineRunner.initialize(pipe) == expected_result
  end

  test "run returns sequential build number" do
    pipe = %Pipeline{name: "Sequence", tasks: [
      create_task("1"),
    ]
  }

    assert PipelineRunner.run(pipe) == {:ok, 1}
    poll_until_complete pipe, 1
    assert PipelineRunner.run(pipe) == {:ok, 2}
  end

  test "returns history of pipeline runs" do
    pipe = %Pipeline{name: "History", tasks: [
      create_task("1"),
    ]
  }

    PipelineRunner.run(pipe) == {:ok, 1}
    result1 = poll_until_complete pipe, 1
    PipelineRunner.run(pipe) == {:ok, 2}
    result2 = poll_until_complete pipe, 2

    assert PipelineHistory.get(pipe) == [ {1, result1}, {2, result2} ]
  end

  test "runs sequence of tasks" do
    pipe = %Pipeline{name: "Sequence", tasks: [
      create_task("1"),
      create_task("2"),
      create_task("3")
    ]
  }

    expected_result = %PipelineResult{id: 1, name: "Sequence",
      status: :ok, 
      tasks: [
      %TaskResult{name: "Task 1", output: "1\n", status: :ok},
      %TaskResult{name: "Task 2", output: "2\n", status: :ok},
      %TaskResult{name: "Task 3", output: "3\n", status: :ok}
    ]
  }
    {:ok, build_number} = pipe |> PipelineRunner.run
    assert poll_until_complete(pipe, build_number) == expected_result
  end

  test "runs nested tasks" do
    expected_result = %PipelineResult{id: 1, name: "Simple Pipeline",
    status: :ok,
    tasks: [
      %TaskResult{name: "task 1", status: :ok,
      output: "1\n"},
      %PipelineResult{id: 1, name: "task 2",
      status: :ok,
      tasks: [
        %TaskResult{name: "task 2a", status: :ok,
        output: "2a\n"},
        %TaskResult{name: "task 2b", status: :ok,
        output: "2b\n"},
        %TaskResult{name: "task 2c", status: :ok,
        output: "2c\n"},
        ]
      },
      %TaskResult{name: "task 3", status: :ok,
      output: "3\n"}
      ]
    }
    {:ok, build_number} = simple_pipeline |> PipelineRunner.run
    assert poll_until_complete(simple_pipeline, build_number) == expected_result
  end

  test "runs mulitline command" do
    command = """
    echo 1
    echo 2
    """
    pipe = %Pipeline{name: "Multiline Pipeline", tasks:
      [ %Task{name: "Task 1", command: command} ]
      }

    expected_result = %PipelineResult{id: 1, name: "Multiline Pipeline",
    status: :ok,
    tasks: [
      %TaskResult{name: "Task 1", status: :ok,
      output: "1\n2\n"},
      ]
    }
    {:ok, build_number} = pipe |> PipelineRunner.run
    assert poll_until_complete(pipe, build_number) == expected_result
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

  test "result has error status if exit status 1" do
    command = "exit 1"
    pipe = %Pipeline{name: "Failed Pipeline", tasks:
      [ %Task{name: "Error", command: "exit 1"} ]
      }
    expected_result = %PipelineResult{id: 1, name: "Failed Pipeline",
    status: :error,
    tasks: [
      %TaskResult{name: "Error", status: :error,
      output: ""},
      ]
    }

    {:ok, build_number} = pipe |> PipelineRunner.run
    assert poll_until_complete(pipe, build_number) == expected_result
  end

  test "should capture stderr" do
    pipe = %Pipeline{name: "Failed Pipeline", tasks: [
      %Task{name: "Error", command: "echo foo; echo bar 1>&2; exit 1"}
      ]
    }

    expected_result = %PipelineResult{id: 1, name: "Failed Pipeline",
    status: :error,
    tasks: [
      %TaskResult{name: "Error", status: :error,
      output: "foo\nbar\n"},
      ]
    }

    {:ok, build_number} = pipe |> PipelineRunner.run
    assert poll_until_complete(pipe, build_number) == expected_result
  end

  test "working directory defaults to .pipeline" do
    pipe = %Pipeline{name: "Working Dir", tasks: [
      %Task{name: "Working Dir", command: "pwd" }
      ]
    }

    {:ok, build_number} = pipe |> PipelineRunner.run
    pipeline_result = poll_until_complete(pipe, build_number)

    output = Enum.first(pipeline_result.tasks).output
    assert output == Path.join(System.get_env("HOME"), ".pipeline") <> "\n"
  end

  test "result has not started status if predecessor fails" do
    pipe = %Pipeline{name: "Failed Pipeline", tasks: [
      %Task{name: "Error", command: "exit 1"},
      %Task{name: "Not run", command: "echo 2"}
      ]
    }

    expected_result = %PipelineResult{id: 1, name: "Failed Pipeline",
    status: :error,
    tasks: [
      %TaskResult{name: "Error", status: :error,
      output: ""},
      %TaskResult{name: "Not run", status: :not_started,
      output: ""},
      ]
    }

    {:ok, build_number} = pipe |> PipelineRunner.run
    assert poll_until_complete(pipe, build_number) == expected_result
  end
end
