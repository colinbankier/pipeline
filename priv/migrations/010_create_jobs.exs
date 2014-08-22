defmodule Repo.CreateJobs do
  use Ecto.Migration

  def up do
    """
    CREATE TABLE jobs (
      id                    SERIAL,
      name                  varchar(100),
      path                  text[],
      build_number          integer,
      run_number            integer,
      status                varchar(40),
      output                text
    )
    """
  end

  def down do
    "DROP TABLE jobs"
  end
end
