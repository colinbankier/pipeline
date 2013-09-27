defmodule Route do

  import Weber.Route

  @route on("/", :Pipeline.Main, :action)

  def get_route do
    @route
  end
end
