defmodule PipelineApp.PipelineRepoTest do
  use PipelineApp.ModelCase
  import TestHelper

  alias PipelineApp.PipelineRepo

  @valid_attrs %{name: "some content", repository_url: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = PipelineRepo.changeset(%PipelineRepo{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = PipelineRepo.changeset(%PipelineRepo{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "clones a pipeline repo to the configured directory" do
    source_repo = init_git_repo("simple_pipeline")
    IO.inspect source_repo
    working_dir = Application.get_env(:pipeline_app, :working_directory)
    rm_repo(working_dir, "simple_pipeline")
    repo = %PipelineRepo{name: "test", repository_url: source_repo}
    git_repo = PipelineRepo.clone(repo)

    assert git_repo.path == Path.join working_dir, "simple_pipeline"
    assert File.exists?(git_repo.path)
  end
end
