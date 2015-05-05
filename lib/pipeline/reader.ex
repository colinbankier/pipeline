defmodule Pipeline.Reader do

  def list_pipelines do
    pipeline_file_names
    |> read_pipeline_files
  end

  def find_by_name pipeline_name do
    list_pipelines
    |> Enum.find fn(pipeline) ->
      pipeline.name == pipeline_name
    end
  end

  def pipeline_file_names do
    config_dir
    |> File.ls!
    |> Enum.filter(&(String.ends_with?(&1, ".yml")))
    |> Enum.map(&(Path.join(config_dir, &1)))
  end

  def config_dir do
    "test/fixtures/pipelines"
  end

  def read_pipeline_files config_files do
    Enum.map config_files, fn(path) ->
      IO.inspect path
      parse_yaml_file(path)
    end
  end

  def parse_yaml_file file_path do
    Yamex.parse_yaml_file file_path
  end

  def parse_yaml yaml do
    Yamex.parse_yaml yaml
  end
end
