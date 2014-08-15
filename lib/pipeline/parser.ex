defmodule PipelineParser do
  alias Domain.Pipeline
  alias Domain.Task

  def parse_yaml yaml do
    IO.puts "parsing"
    :yamerl_constr.string(String.to_char_list(yaml)) |> parse_tuples
  end

  def parse_yaml_file path do

  end

  def parse_tuples tuple_list do
    Enum.map tuple_list, &convert/1
  end

  def convert(params) do
    try do
      to_string params
    rescue
      e in ArgumentError ->
      IO.puts "convert command"
      IO.inspect params
      type = Enum.find_value(params, &determine_type/1)
      create_struct(type, params)
    end
  end

  def create_struct(:pipeline, params) do
    params_map = Enum.reduce(params, %{}, fn(param, acc) ->
      key = param |> elem(0) |> to_string |> String.to_atom
      value = param |> elem(1) |> parse_tuples
      Map.put(acc, key, value)
    end
    )
    Map.merge(%Pipeline{}, params_map)
  end

  def create_struct(:task, params) do
    %Task{name: "task"}
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
