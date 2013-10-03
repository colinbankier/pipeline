defmodule Route do

  import Weber.Route

  @route on("/", :Pipeline.Main, :action)
  |> on("/manage", :Pipeline.Manage, :action)

  def get_route do
    @route
  end
end
