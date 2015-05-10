defmodule Pipeline.Repo.Migrations.AddJobsBuildId do
  use Ecto.Migration

  def up do
    alter table(:jobs) do
      remove :build_number
      add    :build_id, :integer
    end
  end

  def down do
    alter table(:jobs) do
      add    :build_number, :integer
      remove :build_id
    end

  end
end
