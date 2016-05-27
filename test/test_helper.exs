ExUnit.start

Mix.Task.run "ecto.create", ~w(-r PipelineApp.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r PipelineApp.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(PipelineApp.Repo)

defmodule TestHelper do
  def format_errors(changeset) do
    changeset.errors
    |> Enum.map(fn {field, message} -> "#{field}: #{message}" end)
    |> Enum.join(", ")
  end
end
