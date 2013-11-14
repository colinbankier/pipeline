defmodule Result do
  defrecord PipelineResult, id: nil, name: nil, status: :not_started, tasks: []
  defrecord TaskResult, id: nil, name: nil, status: :not_started, output: ""
end
