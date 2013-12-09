defmodule Poll do
  alias Result.PipelineResult
  import :timer, only: [ sleep: 1 ]

  def poll_until_complete(pipeline) do
    PipelineRunner.current_state(pipeline) |> poll(pipeline)
  end

  def poll(state = PipelineResult[status: :ok], pipeline) do
   state
  end

  def poll(state = PipelineResult[status: :error], pipeline) do
   state
  end

  def poll(state, pipeline) do
   sleep 100
   poll_until_complete pipeline
  end
end
