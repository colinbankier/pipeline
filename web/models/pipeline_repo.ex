defmodule PipelineApp.PipelineRepo do
  alias PipelineApp.PipelineRepo
  use PipelineApp.Web, :model

  schema "pipeline_repos" do
    field :name, :string
    field :repository_url, :string

    timestamps
  end

  @required_fields ~w(name repository_url)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def clone(repo = %PipelineRepo{}) do
    working_dir = Application.get_env(:pipeline_app, :working_directory)
    if not File.exists?(working_dir) do
      File.mkdir_p!(working_dir)
    end
    File.cd! working_dir
    target_dir = repo.repository_url |> Path.basename |> Path.rootname |> Path.expand
    if File.exists?(target_dir) do
      %Git.Repository{path: target_dir}
    else
      {:ok, repo} = Git.clone repo.repository_url
      repo
    end
  end

  def read(repo = %PipelineRepo{}) do
    "foo"
  end
end
