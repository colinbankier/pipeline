import Pipeline.TestHelper

defmodule ParseYAMLTest do
  use ExUnit.Case
  alias Models.Task
  alias Models.Pipeline

  def simple_pipeline_yaml do
     """
     name: Simple Pipeline
     tasks:
       - name: task 1
         command: echo 1
       - name: task 2
         tasks:
           - name: task 2a
             command: echo 2a
           - name: task 2b
             command: echo 2b
           - name: task 2c
             command: echo 2c
       - name: task 3
         command: echo 3
    """
  end

  test "Parse pipeline from YAML string" do
    IO.inspect simple_pipeline
    pipelines = PipelineParser.parse_yaml(simple_pipeline_yaml)

    assert List.first(pipelines) == simple_pipeline
  end

  test "Parse pipeline from file" do
    yaml_path = "test/resources/simple_pipeline.yaml"
    { :ok, pipeline } = PipelineParser.parse_yaml_file(Path.expand(yaml_path))
    assert pipeline == simple_pipeline
  end
end
