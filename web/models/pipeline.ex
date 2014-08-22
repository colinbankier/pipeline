defmodule Pipeline.Models.Pipeline do
  use Ecto.Model
  import Ecto.Query
  alias Pipeline.Models.Pipeline

  schema "tasks" do
      field :name
      field :command
      field :pipeline_id, :integer
  end

  def find id do
    query = from p in Pipeline,
      where: p.id == ^id,
      limit: 1

    Repo.one(query)
  end

  def top_level_pipelines do
    query = from p in Pipeline,
      where: p.pipeline_id == nil

    Repo.all(query)
  end

end
