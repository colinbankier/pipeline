defmodule Pipeline.Manage do
  def action("GET", []) do
    {:render, [project: "pipeline"], []}
  end
end
