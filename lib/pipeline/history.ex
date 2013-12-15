defmodule PipelineHistory do
  alias Result.PipelineResult
  alias Result.TaskResult
  use Rethinkdb

  def store result do
    r.table("task_results").insert(to_map(result)).run!
  end

  def to_map result do
    [
      name: result.name,
      path: result.path,
      pipeline_build_number: result.pipeline_build_number,
      build_number: result.build_number,
      status: result.status,
      output: result.output
    ]
  end

  def get path, pipeline_build_number, build_number do
    r.table("task_results").filter( path: path,
      pipeline_build_number: pipeline_build_number,
      build_number: build_number
    ).run! |>
    to_record
  end

  def to_record dict do
    dict
  end

  def get pipeline do

  end
end
