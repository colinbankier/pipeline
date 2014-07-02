defmodule PipelineApp do

  @doc """
  The application callback used to start this
  application and its Dynamos.
  """
  def start(_type, _args) do
  end

  def default_working_dir do
    Path.join(System.get_env("HOME"), ".pipeline")
  end
end
