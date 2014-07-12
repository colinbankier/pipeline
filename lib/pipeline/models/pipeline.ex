defmodule Pipeline.Models.Pipeline do
  use Ecto.Model

  schema "tasks" do
      field :name
  end
end
