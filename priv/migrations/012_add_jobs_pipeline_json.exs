defmodule Repo.AddJobsPipelineJSON do
  use Ecto.Migration

  def up do
    """
    ALTER TABLE jobs ADD COLUMN pipeline_json  text;
    """
  end

  def down do
    """
    ALTER TABLE jobs DROP COLUMN(pipeline_json);
    """
  end
end
