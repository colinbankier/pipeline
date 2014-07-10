defmodule Pipeline.Router do
  use Phoenix.Router

  plug Plug.Static, at: "/static", from: :pipeline
  get "/", Pipeline.Controllers.Pages, :index, as: :page
  resources "pipelines", Pipeline.Controllers.Pipelines
end
