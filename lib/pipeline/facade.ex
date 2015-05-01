defmodule Pipeline.Facade do
  alias Pipeline.Presenter

  def pipelines do
    Pipeline.Reader.list_pipelines
    |> Presenter.top_level
  end
end
