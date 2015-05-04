defmodule PipelineFacadeTest do
  use ExUnit.Case
  alias Pipeline.Facade

  @poll_attempts 10

  test "Can list available pipelines and first levels." do
    pipelines = Facade.pipelines

    assert pipelines == [
      [
        name: "Simple Pipeline",
        tasks: [
          [name: "task 1"],
          [name: "task 2"],
          [name: "task 3"]
        ]
      ]
    ]
  end

  test "Can run a simple pipeline" do
    {:ok, build_number} = Facade.run "Simple Pipeline"
    poll_until_complete("Simple Pipeline", build_number, @poll_attempts)

    result = Facade.result "Simple Pipeline", build_number
    expected = [
      name: "Simple Pipeline",
      status: :success,
      tasks: [
        [name: "task 1", output: "1\n", status: :success],
        [name: "task 2",
        status: :success,
        tasks: [
          [name: "task 2a", output: "2a\n", status: :success ],
          [name: "task 2b", output: "2b\n", status: :success ],
          [name: "task 2c", output: "2c\n", status: :success ],
          ]
        ],
        [name: "task 3", output: "3\n", status: :success],
      ]
    ]

    assert result == expected
  end

  def poll_until_complete(pipeline_name, build_number, count) do
    case Facade.status(pipeline_name, build_number) do
      {:ok, pipeline} -> :ok
      _ ->
        :timer.sleep 100
        poll_until_complete(pipeline_name, build_number, count - 1)
    end
  end

end
