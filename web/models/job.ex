defmodule Models.Job do
  use Ecto.Model

  schema "jobs" do
    field :name
    field :pipeline_json
    field(:path, {:array, :string})
    field :build_number, :integer
    field :run_number, :integer
    field :status
    field :output
  end
end
