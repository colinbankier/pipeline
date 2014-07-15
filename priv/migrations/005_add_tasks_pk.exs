defmodule Repo.AddPK do
  use Ecto.Migration

  def up do
    """
    ALTER TABLE tasks ADD PRIMARY KEY (id);
    """
  end

  def down do
    """
    ALTER TABLE tasks DROP PRIMARY KEY(id);
    """
  end
end
