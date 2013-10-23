defmodule PipelineCreatorTest do
  use ExUnit.Case

  test "Saves a new pipeline" do
    pipeline = Pipeline.Models.Pipeline.new(name: "My Pipeline")
    PipelineCreator.save pipeline

    assert PipelineCreator.list == [pipeline]
  end
end
