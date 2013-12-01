import Pipeline.TestHelper

defmodule FindTaskTest do
  use ExUnit.Case
  alias Models.Pipeline
  alias Models.Task
  alias Result.TaskResult
  alias Result.PipelineResult

  test "Find next task simple" do
    task = Task.new(name: "task 1")
    next_task = PipelineRunner.find_next_task(task, simple_pipeline)

    assert next_task.name == "task 2"
  end

  test "Find top level pipeline" do
    task = PipelineRunner.find(["Simple Pipeline"], simple_pipeline)
    IO.puts "task:"
    IO.inspect task
    assert task.name == "Simple Pipeline"
  end

  test "Find top level task" do
    task = PipelineRunner.find(["Simple Pipeline", "task 2"], simple_pipeline)
    IO.puts "task:"
    IO.inspect task
    assert task.name == "task 2"
  end

  test "Find nested task" do
    task = PipelineRunner.find ["Simple Pipeline", "task 2", "task 2a"], simple_pipeline

    assert task.name == "task 2a"
  end
end
