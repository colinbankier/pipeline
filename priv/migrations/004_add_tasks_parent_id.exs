defmodule Repo.AddPipelineID do
  use Ecto.Migration

  def up do
    """
    ALTER TABLE tasks ADD COLUMN pipeline_id  integer;
    """
  end

  def down do
    """
    ALTER TABLE tasks DROP COLUMN(pipeline_id);
    """
  end
end
