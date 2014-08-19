defmodule PipelineParser do
  alias Domain.Pipeline
  alias Domain.Task

  def parse_yaml yaml do
    try do
      :yamerl_constr.string(String.to_char_list(yaml))
      |> parse_tuples
      |> List.first
    catch
      e -> {:error, e}
    end
  end

  def parse_yaml_file path do
    try do
      :yamerl_constr.file(String.to_char_list(path))
      |> parse_tuples
      |> List.first
    catch
      e -> {:error, e}
    end
  end

  def parse_tuples tuple_list do
    Enum.map tuple_list, &convert_tuple_list/1
  end

  def convert_tuple_list list do
    type = Enum.find_value(list, &determine_type/1)
    create_struct(type, list)
  end

  def convert(params) do
    try do
      to_string params
    rescue
      e in ArgumentError ->
        parse_tuples params
    end
  end

  def params_to_map params do
    Enum.reduce(params, %{}, fn(param, acc) ->
      key = param |> elem(0) |> to_string |> String.to_atom
      value = param |> elem(1) |> convert
      Map.put(acc, key, value)
    end
    )
  end

  def create_struct(:pipeline, params) do
    map = params |> params_to_map
    Map.merge(%Pipeline{}, map)
  end

  def create_struct(:task, params) do
    map = params |> params_to_map
    Map.merge(%Task{}, map)
  end

  def determine_type({'command', _}) do
   :task
  end

  def determine_type({'tasks', _}) do
   :pipeline
  end

  def determine_type({_, _}) do
   nil
  end
end
