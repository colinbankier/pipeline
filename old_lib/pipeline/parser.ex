defmodule PipelineParser do

  alias Models.Pipeline
  alias Models.Task

  def parse_file(filename) do
    {:ok, json} = File.read filename
    parse(json)
  end

  def parse(json) do
    {:ok, data} = JSX.decode json
    pipeline = convert data
    {:ok, pipeline}
  end

  def convert elem do
    cond do
      Dict.has_key? elem, "tasks" ->
        %Pipeline{name: elem["name"],
         tasks: Enum.map(elem["tasks"], &(convert(&1)))}
      Dict.has_key? elem, "command" ->
        %Task{name: elem["name"], command: elem["command"]}
    end
  end
end
