defmodule Pipeline.Repo.Migrations.AddJobsConstraint do
  use Ecto.Migration

  def up do
    execute """
    ALTER TABLE jobs ADD CONSTRAINT jobs_unique UNIQUE (path, build_number, run_number);
    """
  end

  def down do
    execute """
    ALTER TABLE jobs DROP CONSTRAINT jobs_unique;
    """
  end
end
