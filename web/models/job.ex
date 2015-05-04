defmodule Models.Job do
  use Ecto.Model
  alias Models.Job
  alias Pipeline.Repo

  schema "jobs" do
    field :name
    field :pipeline_json
    field(:path, {:array, :string})
    field :build_number, :integer
    field :run_number, :integer
    field :status
    field :output
  end

  def next_build_number do
    query = from j in Job,
      order_by: [desc: j.build_number],
      limit: 1
    job = Repo.one(query)
    job |> inc_build_number
  end

  def inc_build_number nil do
    1
  end

  def inc_build_number job do
   job.build_number + 1
  end
end