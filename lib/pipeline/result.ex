defmodule Result do
  defrecord PipelineResult, id: nil, name: nil, path: nil, pipeline_build_number: nil, build_number: nil, status: :not_started, tasks: []
  defrecord TaskResult, id: nil, name: nil, path: nil, pipeline_build_number: nil, build_number: nil, status: :not_started, output: ""
end
