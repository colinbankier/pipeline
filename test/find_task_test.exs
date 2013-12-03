import Pipeline.TestHelper

defmodule FindTaskTest do
  use ExUnit.Case
  alias Models.Pipeline
  alias Models.Task
  alias Result.TaskResult
  alias Result.PipelineResult

  test "Find next task simple" do
    next_task = PipelineRunner.find_next_task(["Simple Pipeline", "task 1"], simple_pipeline)

    assert next_task == ["Simple Pipeline", "task 2", "task 2a"]
  end

  test "Find next task nested" do
    next_task = PipelineRunner.find_next_task(["Simple Pipeline", "task 2", "task 2a"], simple_pipeline)

    assert next_task == ["Simple Pipeline", "task 2", "task 2b"]
  end

  test "Find next task last nested" do
    next_task = PipelineRunner.find_next_task(["Simple Pipeline", "task 2", "task 2c"], simple_pipeline)

    assert next_task == ["Simple Pipeline", "task 3"]
  end

  test "Find next task last" do
    next_task = PipelineRunner.find_next_task(["Simple Pipeline", "task 3"], simple_pipeline)

    assert next_task == nil
  end

  test "Find top level pipeline" do
    task = PipelineRunner.find(["Simple Pipeline"], simple_pipeline)
    assert task.name == "Simple Pipeline"
  end

  test "Find top level task" do
    task = PipelineRunner.find(["Simple Pipeline", "task 2"], simple_pipeline)
    assert task.name == "task 2"
  end

  test "Find nested task" do
    task = PipelineRunner.find ["Simple Pipeline", "task 2", "task 2a"], simple_pipeline

    assert task.name == "task 2a"
  end

  test "Find top level pipeline result" do
    task = PipelineRunner.find(["Simple Pipeline"], simple_initialized_pipeline_result)
    assert task.name == "Simple Pipeline"
  end

  test "Find top level task result" do
    task = PipelineRunner.find(["Simple Pipeline", "task 2"], simple_initialized_pipeline_result)
    assert task.name == "task 2"
  end

  test "Find nested task result" do
    task = PipelineRunner.find ["Simple Pipeline", "task 2", "task 2a"], simple_initialized_pipeline_result

    assert task.name == "task 2a"
  end
end
