defmodule PipelineApp.PipelineRepoTest do
  use PipelineApp.ModelCase

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
end
