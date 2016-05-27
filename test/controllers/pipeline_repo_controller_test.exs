defmodule PipelineApp.PipelineRepoControllerTest do
  use PipelineApp.ConnCase

  alias PipelineApp.PipelineRepo
  @valid_attrs %{name: "some content", repository_url: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, pipeline_repo_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    pipeline_repo = Repo.insert! %PipelineRepo{}
    conn = get conn, pipeline_repo_path(conn, :show, pipeline_repo)
    assert json_response(conn, 200)["data"] == %{"id" => pipeline_repo.id,
      "name" => pipeline_repo.name,
      "repository_url" => pipeline_repo.repository_url}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, pipeline_repo_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, pipeline_repo_path(conn, :create), pipeline_repo: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(PipelineRepo, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, pipeline_repo_path(conn, :create), pipeline_repo: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    pipeline_repo = Repo.insert! %PipelineRepo{}
    conn = put conn, pipeline_repo_path(conn, :update, pipeline_repo), pipeline_repo: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(PipelineRepo, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    pipeline_repo = Repo.insert! %PipelineRepo{}
    conn = put conn, pipeline_repo_path(conn, :update, pipeline_repo), pipeline_repo: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    pipeline_repo = Repo.insert! %PipelineRepo{}
    conn = delete conn, pipeline_repo_path(conn, :delete, pipeline_repo)
    assert response(conn, 204)
    refute Repo.get(PipelineRepo, pipeline_repo.id)
  end
end
