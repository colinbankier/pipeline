defmodule Repo.AddCommandColumn do
  use Ecto.Migration

  def up do
    """
    ALTER TABLE tasks ADD COLUMN command text;
    """
  end

  def down do
    """
    ALTER TABLE tasks DROP COLUMN command;
    """
  end
end
