defmodule Pipeline.Models do

  defrecord Pipeline, name: nil
end

defmodule Models.Pipeline do
  use Ecto.Model

  queryable "pipelines" do
    field :name, :string
    has_many :tasks, Models.Task
  end
end

defmodule Models.Task do
  use Ecto.Model

  queryable "tasks" do
    field :name, :string
    belongs_to :pipeline, Models.Pipeline
  end
end
