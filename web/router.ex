defmodule PipelineApp.Router do
  use PipelineApp.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", PipelineApp do
    pipe_through :api

    scope "/v1" do
      post "/registrations", RegistrationController, :create
      resources "/pipeline_repos", PipelineRepoController, except: [:new, :edit]
    end
  end

  scope "/", PipelineApp do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

  end
end
