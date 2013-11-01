import Pipeline.TestHelper

defmodule ParsePipelineTest do
  use ExUnit.Case
  alias Models.Task
  alias Models.Pipeline

  test "Parse pipeline from JSON string" do
    { :ok, pipeline} = PipelineParser.parse(simple_pipeline_json)

    assert pipeline == simple_pipeline
  end
end
