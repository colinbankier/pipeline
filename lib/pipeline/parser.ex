defmodule PipelineParser do

  def read(filename) do

  end

  def parse(json) do
    {:ok, data} = JSEX.decode json
    Enum.map data, &(convert(&1))
  end

  def convert elem do
    Pipeline.new name: elem[:name]
  end
end
