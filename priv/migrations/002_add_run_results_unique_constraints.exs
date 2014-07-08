defmodule Repo.AddRunResultUniqueConstraints do
  use Ecto.Migration

  def up do
    """
    ALTER TABLE run_results ADD CONSTRAINT run_results_unique UNIQUE (path, pipeline_build_number, build_number);
    """
  end

  def down do
    """
    ALTER TABLE run_results DROP CONSTRAINT run_results_unique;
    """
  end
end
