defmodule Pipeline.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def up do
    "CREATE TABLE tasks ( id   serial, name varchar(255), pipeline_id int); "
  end

  def down do
    "DROP TABLE IF EXISTS tasks;"
  end
end
