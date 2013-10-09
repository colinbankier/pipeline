defmodule Pipeline.ManagePipeline.Create do
  def create("POST", []) do
    IO.puts "Create {params}"
    { :redirect, "/manage" }
    # {:render, [project: "pipeline"], []}
  end
end
