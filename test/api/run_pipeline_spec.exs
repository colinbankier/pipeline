defmodule RunPipelineTest do
  use ExUnit.Case
  alias Pipeline.ApiDriver, as: Api

  setup do
    Api.start
    :ok
  end

  test "Runs an entire pipeline" do
    job = Api.post("jobs", %{source_repo: "simple_pipeline"}, [{"Content-Type", "application/json"}]).body
    IO.inspect job
    {result, pipeline} = poll_until_complete(10)
    IO.inspect pipeline
    assert result == :ok
  end

  def poll_until_complete(count) when count <= 0 do
    pipeline = Api.get("status/simple_pipeline").body
    {:timeout, pipeline}
  end

  def poll_until_complete(count) do
    pipeline = Api.get("status/simple_pipeline").body
    if successful(pipeline) do
      {:ok, pipeline}
    else
      :timer.sleep 100
      poll_until_complete(count - 1)
    end
  end

  def successful(pipeline = %{"tasks" => tasks}) do
    tasks_complete = Enum.reduce tasks, true, fn(task, acc) ->
      acc && successful(task)
    end
    pipeline.status == "success" && tasks_complete
  end

  def successful(task = %{"command" => _}) do
    task.status == "success"
  end
end
