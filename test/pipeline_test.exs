defmodule PipelineTest do
  use ExUnit.Case
  alias Pipeline.Task

  test "runs sequence of tasks" do
    pipe = [
      create_task("echo \"1\""),
      create_task("echo \"2\""),
      create_task("echo \"3\"")
    ]

    expected_result = [
      task_result("echo \"1\"", "1\n"),
      task_result("echo \"2\"", "2\n"),
      task_result("echo \"3\"", "3\n")
    ]
    assert Pipeline.run(pipe) == expected_result
  end

  test "runs nested tasks" do
    pipe = [
      create_task("echo \"1\""),
      [
        create_task("echo \"2a\""),
        create_task("echo \"2b\""),
        create_task("echo \"2c\"")
      ],
      create_task("echo \"3\"")
    ]

    expected_result = [
      task_result("echo \"1\"", "1\n"),
      task_result("echo \"2a\"", "2a\n"),
      task_result("echo \"2b\"", "2b\n"),
      task_result("echo \"2c\"", "2c\n"),
      task_result("echo \"3\"", "3\n")
    ]
    assert Pipeline.run(pipe) == expected_result
  end

  test "runs mulitline command" do
    command = """
    echo "1"
    echo "2"
    """
    pipe = [ create_task(command) ]

    expected_result = [
        task_result(command, "1\n2\n")
    ]
    assert Pipeline.run(pipe) == expected_result
  end

  test "result has success status if exit status 0" do
    command = "exit 0"
    pipe = [ create_task(command) ]

    expected_result = [
        task_result(command, "", :success)
    ]
    assert Pipeline.run(pipe) == expected_result
  end

  def create_task(cmd) do
    Task.new cmd: cmd
  end

  def task_result(command, output, status // :success) do
    [
      cmd: command,
      output: output,
      status: status
    ]
  end
end
