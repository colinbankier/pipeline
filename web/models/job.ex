defmodule Job do
  use Ecto.Model

  schema "jobs" do
    field :type
    field :name
    field(:path, {:array, :string})
    field :pipeline_build_number, :integer
    field :build_number, :integer
    field :status
    field :output
  end
end
