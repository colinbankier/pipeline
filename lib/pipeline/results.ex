defmodule Pipeline.Results do
  import Ecto.Query
  alias Models.Job
  alias Models.Build
  alias Pipeline.Parser
  alias Pipeline.Repo
  alias Domain.Pipeline
  alias Domain.Task

  defmodule PipelineResult do
    defstruct type: :pipeline_result, id: nil, name: nil, path: nil, pipeline_build_number: nil, build_number: nil, status: :not_started, tasks: []
  end
  defmodule TaskResult do
    defstruct type: :task_result, id: nil, name: nil, path: nil, pipeline_build_number: nil, build_number: nil, status: :not_started, output: ""
  end

  def pipeline_status pipeline, build_number do
    fetch_job_results pipeline, [], build_number
  end

  def pipeline_status pipeline do
    pipeline_status pipeline, latest_build_number(pipeline.name)
  end

  def pipeline_status_history pipeline do
    pipeline.name
    |> build_numbers
    |> Enum.map fn build_number ->
      pipeline_status(pipeline, build_number)
    end
  end

  def find_job job_id do
    Repo.get(Job, job_id)
  end

  defp pipeline_result(pipeline, task_results) do
    %PipelineResult{name: pipeline.name, tasks: task_results, status: :success}
  end

  defp fetch_job_results(pipeline = %Pipeline{}, parent_path, build_number) do
    path = append(parent_path, pipeline.name)
    job_results = Enum.map pipeline.tasks, fn(task) ->
      fetch_job_results(task, path, build_number)
    end
    pipeline_result pipeline, job_results
  end

  defp fetch_job_results(task = %Task{}, parent_path, build_number) do
    path = append(parent_path, task.name)
    query = from j in Job,
      where: j.path == ^path,
      where: j.build_number == ^build_number,
      order_by: [desc: j.run_number],
      limit: 1
    Repo.one(query) |> task_result
  end

  defp task_result(job) do
    IO.inspect job
    %TaskResult{
      name: job.name,
      output: job.output,
      status: String.to_atom(job.status)
    }
  end

  def build_numbers_query pipeline_name do
    from b in Build,
      select: max(b.build_number),
      where: b.pipeline_name == ^pipeline_name
  end

  def build_numbers(pipeline_name) do
    pipeline_name
    |> build_numbers_query
    |> Repo.all
  end

  def latest_build_number(pipeline_name) do
    pipeline_name
    |> build_numbers_query
    |> limit([j], 1)
    |> Repo.one
  end

  def latest_run_number(path) do
    query = from j in Job,
      where: j.path == ^path,
      order_by: [desc: j.run_number],
      select: j.run_number,
      limit: 1
    Repo.one(query)
  end


  defp append list, item do
    List.insert_at(list, -1, item)
  end
end
