defmodule PipelineParser do

  alias Models.Pipeline
  alias Models.Task

  def read(filename) do

  end

  def parse(json) do
    {:ok, data} = JSEX.decode json
    pipeline = convert data
    {:ok, pipeline}
  end

  def convert elem do
    cond do
      Dict.has_key? elem, "tasks" ->
        Pipeline.new name: elem["name"],
         tasks: Enum.map(elem["tasks"], &(convert(&1)))
      Dict.has_key? elem, "command" ->
        Task.new name: elem["name"], command: elem["command"]
    end
  end
end
