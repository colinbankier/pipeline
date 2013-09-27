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
      task_result("1\n"),
      task_result("2\n"),
      task_result("3\n")
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
      task_result("1\n"),
      task_result("2a\n"),
      task_result("2b\n"),
      task_result("2c\n"),
      task_result("3\n")
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
        task_result("1\n2\n")
    ]
    assert Pipeline.run(pipe) == expected_result
  end

  test "result has ok status if exit status 0" do
    command = "exit 0"
    pipe = [ create_task(command) ]

    expected_result = [
        task_result("", :ok)
    ]
    assert Pipeline.run(pipe) == expected_result
  end

  test "result has error status if exit status 1" do
    command = "exit 1"
    pipe = [ create_task(command) ]

    expected_result = [
        task_result("", :error)
    ]
    assert Pipeline.run(pipe) == expected_result
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
    assert Pipeline.run(pipe) == expected_result
  end

  def create_task(cmd) do
    Task.new cmd: cmd
  end

  def task_result(output, status // :ok) do
    [
      output: output,
      status: status
    ]
  end
end
