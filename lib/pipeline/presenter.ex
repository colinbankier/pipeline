defmodule Pipeline.Presenter do
  alias Pipeline.Results.PipelineResult
  alias Pipeline.Results.TaskResult

  def top_level(pipelines) do
    Enum.map pipelines, &pipeline_top_level/1
  end

  def pipeline_top_level pipeline do
    [
      name: pipeline.name,
      tasks: Enum.map(pipeline.tasks, &task_top_level/1)
    ]
  end

  def task_top_level task do
    [name: task.name]
  end

  def as_keyword(pipeline = %PipelineResult{}) do
    [
      name: pipeline.name,
      status: pipeline.status,
      tasks: Enum.map(pipeline.tasks, &as_keyword/1)
    ]
  end

  def as_keyword(task = %TaskResult{}) do
    [
      name: task.name,
      output: task.output,
      status: task.status
    ]
  end
end
