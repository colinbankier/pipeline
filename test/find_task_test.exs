import Pipeline.TestHelper

defmodule FindTaskTest do
  use ExUnit.Case
  alias Domain.Pipeline
  alias Domain.Task

  test "Find next task simple" do
    next_task = Pipeline.find_next_task(["Simple Pipeline", "task 1"], simple_pipeline)

    assert next_task == ["Simple Pipeline", "task 2"]
  end

  test "Find next task nested" do
    next_task = Pipeline.find_next_task(["Simple Pipeline", "task 2", "task 2a"], simple_pipeline)

    assert next_task == ["Simple Pipeline", "task 2", "task 2b"]
  end

  test "Find next task last nested" do
    next_task = Pipeline.find_next_task(["Simple Pipeline", "task 2", "task 2c"], simple_pipeline)

    assert next_task == ["Simple Pipeline", "task 3"]
  end

  test "Find next task last" do
    next_task = Pipeline.find_next_task(["Simple Pipeline", "task 3"], simple_pipeline)

    assert next_task == nil
  end

  test "Find top level pipeline" do
    task = Pipeline.find(["Simple Pipeline"], simple_pipeline)
    assert task.name == "Simple Pipeline"
  end

  test "Find top level task" do
    task = Pipeline.find(["Simple Pipeline", "task 2"], simple_pipeline)
    assert task.name == "task 2"
  end

  test "Find nested task" do
    task = Pipeline.find ["Simple Pipeline", "task 2", "task 2a"], simple_pipeline

    assert task.name == "task 2a"
  end

  test "Find runnable subtask of a pipeline" do
    path = ["Simple Pipeline"]
    subtask_path = Pipeline.find_sub_task path, simple_pipeline

    assert subtask_path == ["Simple Pipeline", "task 1"]
  end

  test "Find runnable subtask of a nested pipeline" do
    path = ["Simple Pipeline", "task 2"]
    subtask_path = Pipeline.find_sub_task path, simple_pipeline

    assert subtask_path == ["Simple Pipeline", "task 2", "task 2a"]
  end
end
