defmodule Pipeline.PageController do
  use Pipeline.Web, :controller

  plug :action

  def index(conn, _params) do
    render conn, "index.html"
  end
end
