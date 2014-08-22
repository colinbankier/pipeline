defmodule Pipeline.Controllers.Jobs do
  use Phoenix.Controller

  def create(conn, params) do
    {:ok, body} = JSEX.encode %{id: 1}
    json conn, body
  end
end
