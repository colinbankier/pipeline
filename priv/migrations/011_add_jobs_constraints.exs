defmodule Repo.AddJobsUniqueConstraints do
  use Ecto.Migration

  def up do
    """
    ALTER TABLE jobs ADD CONSTRAINT jobs_unique UNIQUE (path, build_number, run_number);
    """
  end

  def down do
    """
    ALTER TABLE jobs DROP CONSTRAINT jobs_unique;
    """
  end
end
