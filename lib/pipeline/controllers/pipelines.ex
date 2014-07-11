defmodule Pipeline.Controllers.Pipelines do
  use Phoenix.Controller

  def index(conn, _params) do
    render conn, "index"
  end

  def create(conn, params) do
    IO.inspect params
    body = """
    {"name": "#{params["name"]}"}
    """
    IO.puts body
    #json conn, %{name: "My first Pipeline"}
    json conn, body
  end
end
