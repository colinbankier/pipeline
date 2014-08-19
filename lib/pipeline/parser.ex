defmodule Pipeline.Parser do
  alias Pipeline.Models.SourceRepo

  def list_pipelines do
    SourceRepo.all |>
    pipeline_file_names |>
    read_pipeline_files |>
    filter_out_read_errors
  end

  def find_by_path path_string do
    Enum.find list_pipelines, fn(pipeline) ->
      IO.puts "Comparing #{pipeline.name} and #{path_string}"
      pipeline.name == path_string
    end
  end

  def pipeline_file_names source_repos do
    repo_dir = "test/resources"
    Enum.map source_repos, fn(repo) ->
      repo_dir <> "/" <> repo.name <> "/" <> "pipeline.yml"
    end
  end

  def read_pipeline_files config_files do
    Enum.map config_files, fn(file_path) ->
      Yamex.parse_yaml_file file_path
    end
  end

  def filter_out_read_errors pipelines do
    Enum.filter pipelines, fn(pipeline) ->
      try do
        {:error, _} = pipeline
        false
      rescue
        e in MatchError ->
        true
      end
    end
  end

end
