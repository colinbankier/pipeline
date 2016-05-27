defmodule PipelineApp.PipelineRepoView do
  use PipelineApp.Web, :view

  def render("index.json", %{pipeline_repos: pipeline_repos}) do
    %{data: render_many(pipeline_repos, PipelineApp.PipelineRepoView, "pipeline_repo.json")}
  end

  def render("show.json", %{pipeline_repo: pipeline_repo}) do
    %{data: render_one(pipeline_repo, PipelineApp.PipelineRepoView, "pipeline_repo.json")}
  end

  def render("pipeline_repo.json", %{pipeline_repo: pipeline_repo}) do
    %{id: pipeline_repo.id,
      name: pipeline_repo.name,
      repository_url: pipeline_repo.repository_url}
  end
end
