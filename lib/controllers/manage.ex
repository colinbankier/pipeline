defmodule Pipeline.Manage do
  def action("GET", []) do
    {:render, [project: "pipeline"], []}
  end

  def new("GET", []) do
    {:render, [project: "pipeline"], []}
  end
end
