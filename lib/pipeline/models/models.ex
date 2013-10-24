defmodule Pipeline.Models do

  defrecord Pipeline, name: nil
end

defmodule Pipeline.Pipeline do
  use Ecto.Model

  queryable "pipelines" do
    field :name, :string
  end
end
