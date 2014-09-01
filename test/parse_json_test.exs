import Pipeline.TestHelper

defmodule ParseJSONTest do
  use ExUnit.Case
  alias Domain.Task
  alias Domain.Pipeline

  test "Parse pipeline from JSON string" do
    {:ok, pipeline} = Pipeline.from_json(simple_pipeline_json)

    assert pipeline == simple_pipeline
  end
end
