defmodule Poll do
  alias Result.PipelineResult
  import :timer, only: [ sleep: 1 ]

  def poll_until_complete(pipeline, build_number) do
    PipelineRunner.current_state(pipeline, build_number) |>
    poll(pipeline, build_number)
  end

  def poll(state = %{status: :ok}, pipeline, build_number) do
   state
  end

  def poll(state = %{status: :error}, pipeline, build_number) do
   state
  end

  def poll(state, pipeline, build_number) do
   sleep 100
   poll_until_complete pipeline, build_number
  end
end
