defmodule Pipeline.Repo do
  use Ecto.Repo, adapter: Ecto.Adapters.Postgres

  def url do
    "ecto://colin.bankier:@localhost/pipeline"
  end
end
