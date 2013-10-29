defmodule Pipeline.Repo.Migrations.CreatePipelines do
  use Ecto.Migration

  def up do
    "CREATE TABLE pipelines ( id   serial, name varchar(255)); "
  end

  def down do
    "DROP TABLE IF EXISTS pipelines;"
  end
end
