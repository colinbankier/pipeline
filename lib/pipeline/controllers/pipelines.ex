defmodule Pipeline.Controllers.Pipelines do
  use Phoenix.Controller

  def index(conn, _params) do
    render conn, "index"
  end

  def create(conn, params) do
    IO.inspect params
    json conn, %{name: "My first Pipeline"}
  end
end
