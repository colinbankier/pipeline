defmodule Repo.AddPipelinelineIdFK do
  use Ecto.Migration

  def up do
    """
    ALTER TABLE tasks ADD FOREIGN KEY (pipeline_id) references tasks(id);
    """
  end

  def down do
    """
    ALTER TABLE tasks DROP FOREIGN KEY(pipeline_id);
    """
  end
end
