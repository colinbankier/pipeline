defmodule Pipeline.Router do
  use Phoenix.Router

  pipeline :static do
    plug Plug.Static, at: "/", from: :pipeline
  end

  get "/", Pipeline.Controllers.Pages, :index, as: :page
  resources "pipelines", Pipeline.Controllers.Pipelines do
    resources "tasks", Pipeline.Controllers.Tasks
  end

  resources "source_repos", Pipeline.Controllers.SourceRepos
  resources "jobs", Pipeline.Controllers.Jobs
  resources "status", Pipeline.Controllers.Status
end
