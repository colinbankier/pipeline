defmodule Repo.AddSourceRepotUniqueConstraint do
  use Ecto.Migration

  def up do
    """
    ALTER TABLE source_repos ADD CONSTRAINT source_repos_unique UNIQUE (name);
    """
  end

  def down do
    """
    ALTER TABLE source_repos DROP CONSTRAINT source_repos_unique;
    """
  end
end
