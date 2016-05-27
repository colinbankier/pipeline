defmodule PipelineApp.Repo.Migrations.CreatePipelineRepo do
  use Ecto.Migration

  def change do
    create table(:pipeline_repos) do
      add :name, :string
      add :repository_url, :string

      timestamps
    end

  end
end
