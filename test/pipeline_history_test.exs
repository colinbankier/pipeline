import Pipeline.TestHelper
import Poll
import PipelineHistory

defmodule PipelineHistoryTest do
  use ExUnit.Case
  alias Models.Pipeline
  alias Models.Task
  alias Result.TaskResult
  alias Result.PipelineResult

  setup do
    :ets.delete_all_objects :pipeline_results
    BuildNumber.clear_all
    Database.setup
    :ok
  end

  test "stores a task result" do
    path = ["A pipeline", "A task"]
    pipeline_build_number = 1
    build_number = 1
    result = TaskResult.new path: path,
      pipeline_build_number: pipeline_build_number,
      build_number: build_number

    store(result)

    assert get(path, pipeline_build_number, build_number) == result
  end

  test "stores a pipeline result" do
    result = PipelineResult.new
    store(result)

    assert get("My Result", 1, 1) == result
  end

  test "returns history of pipeline runs" do
    pipe = Pipeline.new name: "History", tasks: [
      create_task("1"),
    ]

    PipelineRunner.run(pipe) == {:ok, 1}
    result1 = poll_until_complete pipe, 1
    PipelineRunner.run(pipe) == {:ok, 2}
    result2 = poll_until_complete pipe, 2

    assert PipelineHistory.get(pipe) == [ {1, result1}, {2, result2} ]
  end
end
