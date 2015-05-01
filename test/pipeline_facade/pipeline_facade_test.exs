defmodule PipelineFacadeTest do
  use ExUnit.Case
  alias Pipeline.Facade

  test "Can list available pipelines and first levels." do
    pipelines = Facade.pipelines

    assert pipelines == [
      name: "Simple Pipeline",
      tasks: [
        [name: "task 1"],
        [name: "task 2"],
        [name: "task 3"]
      ]
    ]
  end
end
