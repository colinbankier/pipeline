defmodule Models.Job do
  use Ecto.Model
  alias Models.Job
  alias Pipeline.Repo

  schema "jobs" do
    belongs_to :build, Build
    field :name
    field :task_json
    field(:path, {:array, :string})
    field :run_number, :integer
    field :status
    field :output
  end
end
