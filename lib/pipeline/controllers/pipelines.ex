defmodule Pipeline.Controllers.Pipelines do
  use Phoenix.Controller
  import Pipeline.Parser
  alias Pipeline.Models.SourceRepo
  alias Pipeline.Models.Pipeline

  def index(conn, _params) do
    pipelines = SourceRepo.all |>
    pipeline_file_names |>
    read_pipeline_files |>
    filter_out_read_errors

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
