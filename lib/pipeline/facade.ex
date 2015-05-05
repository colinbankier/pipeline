defmodule Pipeline.Facade do
  alias Pipeline.Presenter
  alias Pipeline.Reader
  alias Pipeline.TaskScheduler
  alias Pipeline.Results

  def pipelines do
    Reader.list_pipelines
    |> Presenter.top_level
  end

  def run pipeline_name do
    job = pipeline_name
    |> Reader.find_by_name
    |> TaskScheduler.trigger_task([])

    {:ok, job.build_number}
  end

  def status(pipeline_name, build_number) do
    pipeline_name
    |> Reader.find_by_name
    |> Results.pipeline_status(build_number)
    |> Presenter.as_keyword
  end
end
