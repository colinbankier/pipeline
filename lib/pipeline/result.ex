defmodule Result do
  defmodule PipelineResult do
    defstruct type: :pipeline_result, id: nil, name: nil, path: nil, pipeline_build_number: nil, build_number: nil, status: :not_started, tasks: []
  end
  defmodule TaskResult do
    defstruct type: :task_result, id: nil, name: nil, path: nil, pipeline_build_number: nil, build_number: nil, status: :not_started, output: ""
  end
end
