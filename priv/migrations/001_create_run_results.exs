defmodule Repo.CreateRunResult do
  use Ecto.Migration

  def up do
    """
    CREATE TABLE run_results (
      id                    SERIAL,
      type                  varchar(40),
      name                  varchar(100),
      path                  text[],
      pipeline_build_number integer,
      build_number          integer,
      status                varchar(40),
      output                text
    )
    """
  end

  def down do
    "DROP TABLE run_results"
  end
end
