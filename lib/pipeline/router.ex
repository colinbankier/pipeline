defmodule Pipeline.Router do
  use Phoenix.Router

  plug Plug.Static, at: "/", from: :pipeline
  get "/", Pipeline.Controllers.Pages, :index, as: :page
  resources "pipelines", Pipeline.Controllers.Pipelines do
    resources "tasks", Pipeline.Controllers.Tasks
  end

  resources "source_repos", Pipeline.Controllers.SourceRepos
  resources "jobs", Pipeline.Controllers.Jobs
end
