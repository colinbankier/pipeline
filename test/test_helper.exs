Dynamo.under_test(PipelineApp.Dynamo)
Dynamo.Loader.enable
ExUnit.start

defmodule Pipeline.TestCase do
  use ExUnit.CaseTemplate

  # Enable code reloading on test cases
  setup do
    Dynamo.Loader.enable
    :ok
  end
end
