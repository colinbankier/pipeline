defmodule PipelineApp.PageController do
  use PipelineApp.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
