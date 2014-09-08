defmodule RunPipelineTest do
  use ExUnit.Case
  alias Pipeline.ApiDriver, as: Api

  setup do
    Api.start
    :ok
  end

  test "Runs an entire pipeline" do
    res = Api.post("jobs", %{source_repo: "simple_pipeline"}, [{"Content-Type", "application/json"}])
    IO.inspect res
    assert res == []
  end
end
