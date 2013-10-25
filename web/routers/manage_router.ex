defmodule ManageRouter do
  use Dynamo.Router

  get "/" do
    conn = conn.assign(:title, "Manage Pipelines")
    render conn, "manage/index.html"
  end

  get "pipeline/new" do
    conn = conn.assign(:title, "New Pipeline")
    render conn, "manage/pipeline/new.html"
  end

  post "pipeline/new" do
    pipeline = Pipeline.Pipeline.new name: conn.params[:name]
    pipeline = Pipeline.Repo.create pipeline
    redirect conn, to: "/manage/pipeline/#{pipeline.id}"
  end

  get "pipeline/:id" do
    {id, _} = String.to_integer conn.params[:id]
    pipeline = Pipeline.Repo.get Pipeline.Pipeline, id
    conn = conn.assign(:name, pipeline.name)
    render conn, "manage/pipeline/show.html"
  end
end
