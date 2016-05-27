ExUnit.start

Mix.Task.run "ecto.create", ~w(-r PipelineApp.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r PipelineApp.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(PipelineApp.Repo)

defmodule TestHelper do
  use ExUnit.Case

  def format_errors(changeset) do
    changeset.errors
    |> Enum.map(fn {field, message} -> "#{field}: #{message}" end)
    |> Enum.join(", ")
  end

  def rm_repo(working_dir, name) do
    assert working_dir =~ "_test"
    Path.join(working_dir, name) |> File.rm_rf!
  end

  def init_git_repo(name) do

  end
end
