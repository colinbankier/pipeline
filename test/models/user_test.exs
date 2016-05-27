defmodule PipelineApp.UserTest do
  use PipelineApp.ModelCase
  import TestHelper

  alias PipelineApp.User

  @valid_attrs %{email: "user@pipeline.org", password: "some content", password_confirmation: "some content", first_name: "some content", last_name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?, format_errors(changeset)
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
