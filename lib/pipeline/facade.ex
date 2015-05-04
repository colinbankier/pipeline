defmodule Pipeline.Facade do
  alias Pipeline.Presenter
  alias Pipeline.Reader
  alias Pipeline.TaskScheduler

  def pipelines do
    Reader.list_pipelines
    |> Presenter.top_level
  end

  def run pipeline_name do
    Reader.list_pipelines
    |> Enum.find(fn pipeline ->
      pipeline.name == pipeline_name
    end)
    |> TaskScheduler.trigger_task([])
  end
end
