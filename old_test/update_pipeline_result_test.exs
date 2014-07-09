import Pipeline.TestHelper

defmodule UpdatePipelineResultTest do
  use ExUnit.Case
  alias Models.Pipeline
  alias Models.Task
  alias Result.TaskResult
  alias Result.PipelineResult

  test "replaces task result in pipeline" do
    pipeline_result = simple_initialized_pipeline_result
    task_result = %TaskResult{name: "updated task", status: :ok}
    path = ["Simple Pipeline", "task 2", "task 2b"]
    IO.inspect pipeline_result
    result = PipelineRunner.update_pipeline_result pipeline_result, path, task_result
    IO.inspect result

    assert PipelineRunner.find(["Simple Pipeline", "task 2", "updated task"], result) == task_result
  end
end
