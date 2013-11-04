defmodule Result do
  defrecord PipelineResult, name: nil, status: :not_started
  defrecord TaskResult, name: nil, status: :not_started, output: ""
end
