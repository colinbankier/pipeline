
defmodule Pipeline.ManagePipeline.New do
  import Weber.Http.Params

  def new("GET", []) do
    IO.inspect Weber.Http.Params.post_param("name")
    name = param(:name)
    IO.inspect name
    {:render, [project: "pipeline"], []}
  end
end
