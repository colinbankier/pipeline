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
    {id, _} = Integer.parse conn.params[:id]
    pipeline = Pipeline.Repo.get Pipeline.Pipeline, id
    conn = conn.assign(:pipeline, pipeline)
    IO.inspect pipeline.tasks
    render conn, "manage/pipeline/show.html"
  end

  get "pipeline/:id/task/new" do
    render conn, "manage/pipeline/task/new.html"
  end

  post "pipeline/:pipeline_id/task/new" do
    {pipeline_id, _} = Integer.parse conn.params[:pipeline_id]
    task = Pipeline.Task.new name: conn.params[:name],
      pipeline_id: pipeline_id
    task = Pipeline.Repo.create task
    redirect conn, to: "/manage/pipeline/#{pipeline_id}"
  end
end
