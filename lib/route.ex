defmodule Route do

  import Weber.Route

  @route on("/", :Pipeline.Main, :action)
  |> on("/manage", :Pipeline.Manage, :action)
  |> on("/manage/pipeline/new", :Pipeline.ManagePipeline.New, :new)
  |> on("/manage/pipeline/create", :Pipeline.ManagePipeline.Create, :create)
  |> on("/manage/pipeline/testcreate", :Pipeline.ManagePipeline.TestCreate, :testcreate)
  def get_route do
    @route
  end
end
