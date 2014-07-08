defmodule Result do
  defmodule PipelineResult do
    defstruct type: :pipeline_result, id: nil, name: nil, path: nil, pipeline_build_number: nil, build_number: nil, status: :not_started, tasks: []
  end
  defmodule TaskResult do
    defstruct type: :task_result, id: nil, name: nil, path: nil, pipeline_build_number: nil, build_number: nil, status: :not_started, output: ""
  end

  defmodule RunResult do
    use Ecto.Model

    schema "run_results" do
      field :type
      field :name
      field(:path, {:array, :string})
      field :pipeline_build_number, :integer
      field :build_number, :integer
      field :status
      field :output
    end

  end
end
