defmodule Pipeline.ManagePipeline.Create do
  import Weber.Http.Params

  def create("POST", []) do
    IO.inspect Weber.Http.Params.post_param("Create")
    IO.inspect Weber.Http.Params.post_param("name")
    { :redirect, "/manage" }
    # {:render, [project: "pipeline"], []}
  end
end
