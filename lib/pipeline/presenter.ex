defmodule Pipeline.Presenter do
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
end
