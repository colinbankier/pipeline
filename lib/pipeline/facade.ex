defmodule Pipeline.Facade do
  alias Pipeline.Presenter
  alias Pipeline.Reader
  alias Pipeline.TaskScheduler
  alias Pipeline.Results

  def pipelines do
    Reader.list_pipelines
    |> Presenter.top_level
  end

  def run(path = [pipeline_name | _], build_number) when is_list(path) do
    job = pipeline_name
    |> Reader.find_by_name
    |> TaskScheduler.trigger_task(path)

    {:ok, job.build_number}
  end

  def run pipeline_name do
    job = pipeline_name
    |> Reader.find_by_name
    |> TaskScheduler.trigger_build

    {:ok, job.build_number}
  end

  def status(pipeline_name) do
    pipeline_name
    |> Reader.find_by_name
    |> Results.pipeline_status
    |> Presenter.as_keyword
  end

  def status(pipeline_name, build_number) do
    pipeline_name
    |> Reader.find_by_name
    |> Results.pipeline_status(build_number)
    |> Presenter.as_keyword
  end
end
