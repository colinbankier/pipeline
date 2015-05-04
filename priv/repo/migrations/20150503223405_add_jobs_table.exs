defmodule Pipeline.Repo.Migrations.AddJobsTable do
  use Ecto.Migration

  def change do
    create table(:jobs) do
      add :name, :string, size: 40
      add :path, {:array, :string}
      add :build_number, :integer
      add :run_number, :integer
      add :status, :string, size: 40
      add :output, :text
      add :pipeline_json, :text
    end
  end
end
