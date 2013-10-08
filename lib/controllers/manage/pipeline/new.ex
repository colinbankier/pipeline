
defmodule Pipeline.ManagePipeline.New do
  def new("GET", []) do
    {:render, [project: "pipeline"], []}
  end
end
