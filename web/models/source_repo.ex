defmodule Pipeline.Models.SourceRepo do
  use Ecto.Model
  import Ecto.Query
  alias Pipeline.Models.SourceRepo

  schema "source_repos" do
      field :name
  end

  def all do
    query = from e in SourceRepo,
      select: e

    Repo.all(query)
  end

  def find id do
    query = from p in SourceRepo,
      where: p.id == ^id,
      limit: 1

    Repo.one(query)
  end
end
