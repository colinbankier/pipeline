defmodule Pipline.Router do
  use Phoenix.Router

  pipeline :browser do
    plug :accepts, ~w(html)
    plug :fetch_session
    plug Plug.Static, at: "/", from: :pipeline
  end

  pipeline :api do
    plug :accepts, ~w(json)
  end

  scope "/", Pipline do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "pipelines", Pipeline.Controllers.Pipelines do
     resources "tasks", Pipeline.Controllers.Tasks
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", Pipline do
  #   pipe_through :api
  # end
end
