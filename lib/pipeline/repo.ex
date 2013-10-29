defmodule Repo do
  use Ecto.Repo, adapter: Ecto.Adapters.Postgres

  def url do
    "ecto://colin.bankier:@localhost/pipeline"
  end

  def priv do
    app_dir(:pipeline, "db/migrations")
  end
end
