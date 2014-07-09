import Pipeline.TestHelper

defmodule ParsePipelineTest do
  use ExUnit.Case
  alias Models.Task
  alias Models.Pipeline

  test "Parse pipeline from JSON string" do
    { :ok, pipeline} = PipelineParser.parse(simple_pipeline_json)

    assert pipeline == simple_pipeline
  end

  test "Parse pipeline from file" do
    json_path = "test/resources/simple_pipeline.json"
    { :ok, pipeline } = PipelineParser.parse_file(Path.expand(json_path))
    assert pipeline == simple_pipeline
  end
end
