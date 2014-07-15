defmodule Pipeline.Models.Pipeline do
  use Ecto.Model
  import Ecto.Query
  alias Pipeline.Models.Pipeline

  schema "tasks" do
      field :name
      field :pipeline_id, :integer
  end

  def find id do
    query = from p in Pipeline,
      where: p.id == ^id,
      limit: 1

    Repo.one(query)
  end

end
