Code.require_file "../test_helper.exs", __FILE__
Pipeline.Repo.start_link

defmodule PipelineModelTest do
  use ExUnit.Case

  test "Saves and retrieved a new pipeline" do
    pipeline = Pipeline.Pipeline.new(name: "Big Pipe")
    pipeline = Pipeline.Repo.create(pipeline)
    retrieved_pipeline = Pipeline.Repo.get Pipeline.Pipeline, pipeline.id
    assert retrieved_pipeline.name == "Big Pipe"
  end
end
