defmodule PipelineApp.PipelineRepoController do
  use PipelineApp.Web, :controller

  alias PipelineApp.PipelineRepo

  plug :scrub_params, "pipeline_repo" when action in [:create, :update]

  def index(conn, _params) do
    pipeline_repos = Repo.all(PipelineRepo)
    render(conn, "index.json", pipeline_repos: pipeline_repos)
  end

  def create(conn, %{"pipeline_repo" => pipeline_repo_params}) do
    changeset = PipelineRepo.changeset(%PipelineRepo{}, pipeline_repo_params)

    case Repo.insert(changeset) do
      {:ok, pipeline_repo} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", pipeline_repo_path(conn, :show, pipeline_repo))
        |> render("show.json", pipeline_repo: pipeline_repo)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PipelineApp.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    pipeline_repo = Repo.get!(PipelineRepo, id)
    render(conn, "show.json", pipeline_repo: pipeline_repo)
  end

  def update(conn, %{"id" => id, "pipeline_repo" => pipeline_repo_params}) do
    pipeline_repo = Repo.get!(PipelineRepo, id)
    changeset = PipelineRepo.changeset(pipeline_repo, pipeline_repo_params)

    case Repo.update(changeset) do
      {:ok, pipeline_repo} ->
        render(conn, "show.json", pipeline_repo: pipeline_repo)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PipelineApp.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    pipeline_repo = Repo.get!(PipelineRepo, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(pipeline_repo)

    send_resp(conn, :no_content, "")
  end
end
