defmodule Result do
  defrecord PipelineResult, name: nil, status: :not_started, tasks: []
  defrecord TaskResult, name: nil, status: :not_started, output: ""
end
