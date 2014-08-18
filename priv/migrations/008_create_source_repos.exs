defmodule Repo.CreateSourceRepos do
  use Ecto.Migration

  def up do
    """
    CREATE TABLE source_repos (
      id                    SERIAL,
      name                  varchar(100)
    )
    """
  end

  def down do
    "DROP TABLE source_repos"
  end
end
