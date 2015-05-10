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

    result = Facade.status "Simple Pipeline", build_number
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

  test "Can list results for multiple builds and multiple runs" do
    {:ok, build_number_1} = Facade.run "Simple Pipeline"
    poll_until_complete("Simple Pipeline", build_number_1, @poll_attempts)
    {:ok, build_number_2} = Facade.run "Simple Pipeline"
    poll_until_complete("Simple Pipeline", build_number_2, @poll_attempts)
    {:ok, build_number_2} = Facade.run ["Simple Pipeline", "task 2"], build_number_2
    poll_until_complete("Simple Pipeline", build_number_2, @poll_attempts)

    result = Facade.status_history "Simple Pipeline"
    expected = [
      [
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
      ],
      [
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
    ]

    assert result == expected
  end

  def poll_until_complete(pipeline_name, build_number, count) when count <= 0 do
    raise "poll timed out"
  end

  def poll_until_complete(pipeline_name, build_number, count) do
    result = Facade.status(pipeline_name, build_number)
    case result[:status] do
      :success -> :ok
      _ ->
        :timer.sleep 100
        poll_until_complete(pipeline_name, build_number, count - 1)
    end
  end

end
