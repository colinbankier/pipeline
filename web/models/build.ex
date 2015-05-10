defmodule Models.Build do
  use Ecto.Model

  schema "builds" do
    has_many :jobs, Job
    field :pipeline_name
    field :pipeline_json
    field :build_number, :integer
  end

  def for_pipeline_build pipeline_name, build_number do
    (from b in Build,
      where: b.build_number == ^build_number and
        b.pipeline_name == ^pipeline_name,
      limit: 1)
    |> Repo.one
  end
end
