defmodule Pipeline.ManagePipeline.Create do
  def create("POST", []) do
    IO.puts "Create"
    # {:render, [project: "pipeline"], []}
  end
end
