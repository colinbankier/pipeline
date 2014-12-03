defmodule Results do
  import Ecto.Query
  alias Models.Job
  alias Pipeline.Parser
  alias Domain.Pipeline
  alias Domain.Task

  defmodule PipelineResult do
    defstruct type: :pipeline_result, id: nil, name: nil, path: nil, pipeline_build_number: nil, build_number: nil, status: :not_started, tasks: []
  end
  defmodule TaskResult do
    defstruct type: :task_result, id: nil, name: nil, path: nil, pipeline_build_number: nil, build_number: nil, status: :not_started, output: ""
  end

  def pipeline_status pipeline do
    fetch_job_results pipeline, []
  end

  defp fetch_job_results(pipeline = %Pipeline{}, parent_path) do
    path = append(parent_path, pipeline.name)
    job_results = Enum.map pipeline.tasks, fn(task) ->
      fetch_job_results(task, path)
    end
    pipeline_result pipeline, job_results
  end

  defp pipeline_result(pipeline, task_results) do
    %PipelineResult{name: pipeline.name, tasks: task_results, status: :success}
  end

  defp fetch_job_results(task = %Task{}, parent_path) do
    path = append(parent_path, task.name)
    query = from j in Job,
      where: j.path == array(^path, ^:string),
      order_by: [desc: j.build_number],
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

  defp append list, item do
    List.insert_at(list, -1, item)
  end
end
