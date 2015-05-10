defmodule Pipeline.Repo.Migrations.AddTasksJsonColumn do
  use Ecto.Migration

  def up do
    alter table(:jobs) do
      remove :pipeline_json
      add    :task_json, :text
    end
  end

  def down do
    alter table(:jobs) do
      add    :pipeline_json, :text
      remove :task_json
    end
  end
end
