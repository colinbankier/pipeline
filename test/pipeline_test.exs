defmodule PipelineTest do
  use ExUnit.Case
  alias Pipeline.Task

  test "runs sequence of processes" do
    pipe = [
      create_task("echo \"1\""),
      create_task("echo \"2\""),
      create_task("echo \"3\"")
    ]

    result = Pipeline.run(pipe)
    expected_result = [
      [
        cmd: "echo \"1\"",
        output: "1\n"
      ],
      [
        cmd: "echo \"2\"",
        output: "2\n"
      ],
      [
        cmd: "echo \"3\"",
        output: "3\n"
      ]
    ]

    assert result == expected_result
  end

  def create_task(cmd) do
    Task.new cmd: cmd
  end
end
