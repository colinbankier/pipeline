defmodule Pipeline.Models do

  defrecord Pipeline, name: nil
end

defmodule Pipeline.Pipeline do
  use Ecto.Model

  queryable "pipelines" do
    field :name, :string
    has_many :tasks, Pipeline.Task
  end
end

defmodule Pipeline.Task do
  use Ecto.Model

  queryable "tasks" do
    field :name, :string
    belongs_to :pipeline, Pipeline.Pipeline
  end
end
