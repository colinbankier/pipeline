defmodule Pipeline.Controllers.Pipelines do
  use Phoenix.Controller
  alias Pipeline.Models.SourceRepo
  alias Pipeline.Models.Pipeline

  def index(conn, _params) do
    repo_dir = "test/resources"
    config_files = Enum.map SourceRepo.all, fn(repo) ->
      repo_dir <> "/" <> repo.name <> "/" <> "pipeline.yml"
    end
    IO.inspect config_files

    pipelines = Enum.map config_files, fn(file_path) ->
      PipelineParser.parse_yaml_file file_path
    end
    IO.inspect pipelines
    pipelines = Enum.filter pipelines, fn(pipeline) ->
      try do
        {:error, _} = pipeline
        false
      rescue
        e in MatchError ->
        true
      end
    end
    IO.inspect pipelines
    {:ok, body} = JSEX.encode(%{pipelines: pipelines})
    json conn, body
  end

  def create(conn, params) do
    IO.inspect params
    pipeline = %Pipeline{name: params["name"]}
    pipeline = Repo.insert pipeline

    {:ok, body} = JSEX.encode pipeline
    json conn, body
  end

  def show(conn, params) do
    pipeline = Pipeline.find(String.to_integer(params["id"]))
    {:ok, body} = JSEX.encode pipeline
    json conn, body
  end
end
