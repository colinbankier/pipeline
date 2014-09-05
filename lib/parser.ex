defmodule Pipeline.Parser do
  alias Pipeline.Models.SourceRepo

  def list_pipelines do
    SourceRepo.all |>
    pipeline_file_names |>
    read_pipeline_files |>
    filter_out_read_errors |>
    set_source_repo
  end

  def find_by_path path_string do
    Enum.find list_pipelines, fn(pipeline) ->
      pipeline.source_repo == path_string
    end
  end

  def pipeline_file_names source_repos do
    repo_dir = "test/resources"
    Enum.map source_repos, fn(repo) ->
      %{
        source_repo: repo,
        file_path: repo_dir <> "/" <> repo.name <> "/" <> "pipeline.yml"
      }
    end
  end

  def read_pipeline_files config_files do
    Enum.map config_files, fn(config_map) ->
      Map.put config_map, :pipeline, parse_yaml_file(config_map.file_path)
    end
  end

  def parse_yaml_file file_path do
    Yamex.parse_yaml_file file_path
  end

  def parse_yaml yaml do
    Yamex.parse_yaml yaml
  end

  def filter_out_read_errors pipelines do
    Enum.filter pipelines, fn(config_map) ->
      try do
        {:error, _} = config_map.pipeline
        false
      rescue
        e in MatchError ->
        true
      end
    end
  end

  def set_source_repo config_maps do
    Enum.map config_maps, fn(config_map) ->
      config_map.pipeline |>
      Map.put :source_repo, config_map.source_repo.name
    end
  end

end
