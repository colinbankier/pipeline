defmodule Pipeline.Repo.Migrations.AddBuildsTable do
  use Ecto.Migration

  def change do
    create table(:builds) do
      add :pipeline_name, :string, size: 40
      add :build_number, :integer
      add :pipeline_json, :text
    end
  end
end
