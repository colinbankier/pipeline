ExUnit.start

Mix.Task.run "ecto.create", ~w(-r PipelineApp.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r PipelineApp.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(PipelineApp.Repo)

defmodule TestHelper do
  use ExUnit.Case
  @root_dir File.cwd!

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
    remote_dir = Application.get_env(:pipeline_app, :remote_repo_directory)
    target_dir = Path.join(remote_dir, name <> UUID.uuid1)
    if not File.exists?(remote_dir) do
      File.mkdir_p(remote_dir)
    end
    source_dir = Path.join "test/resources", name
    File.cd! @root_dir
    File.cp_r! source_dir, target_dir
    File.cd! target_dir
    repo = Git.init!
    repo |> Git.add(".")
    repo |> Git.commit("Commit it.")

    repo.path
  end
end
