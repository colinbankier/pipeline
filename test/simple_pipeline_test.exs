defmodule PipelineApp.SimplePipelineTest do
  use ExUnit.Case
  import TestHelper

  alias PipelineApp.PipelineRepo

  setup_all do
    IO.puts "Starting AssertionTest"

    source_repo = init_git_repo("simple_pipeline")
    repo = %PipelineRepo{name: "test", repository_url: source_repo}
    {:ok, repo: repo}
  end

  test "reads pipeline repo", context do
    pipeline = context[:repo] |> PipelineRepo.read

    assert pipeline == [
      name: "Simple Pipeline",
      steps: [
        [name: "task 1", command: "echo 1"],
        [name: "task 2",
         steps: [
           [name: "task 2a", command: "echo 2a" ],
           [name: "task 2b", command: "echo 2b" ],
           [name: "task 2c", command: "echo 2c" ],
         ]
        ],
        [name: "task 3", command: "echo 3"]
      ]
    ]
  end

end
