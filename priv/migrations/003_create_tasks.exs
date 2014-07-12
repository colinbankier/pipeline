defmodule Repo.CreateTasks do
  use Ecto.Migration

  def up do
    """
    CREATE TABLE tasks (
      id                    SERIAL,
      type                  varchar(40),
      name                  varchar(100)
    )
    """
  end

  def down do
    "DROP TABLE tasks"
  end
end
