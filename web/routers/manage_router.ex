defmodule ManageRouter do
  alias Models.Pipeline
  alias Models.Task

  get "/" do
    conn = conn.assign(:title, "Manage Pipelines")
    render conn, "manage/index.html"
  end

  get "pipeline/new" do
    conn = conn.assign(:title, "New Pipeline")
    render conn, "manage/pipeline/new.html"
  end

  post "pipeline/new" do
    pipeline = Pipeline.new name: conn.params[:name]
    pipeline = Repo.create pipeline
    redirect conn, to: "/manage/pipeline/#{pipeline.id}"
  end

  get "pipeline/:id" do
    {id, _} = Integer.parse conn.params[:id]
    pipeline = Repo.get Pipeline, id
    tasks = Repo.all(pipeline.tasks)
    conn = conn.assign(:pipeline, pipeline)
    conn = conn.assign(:tasks, tasks)
    render conn, "manage/pipeline/show.html"
  end

  get "pipeline/:id/task/new" do
    render conn, "manage/pipeline/task/new.html"
  end

  post "pipeline/:pipeline_id/task/new" do
    {pipeline_id, _} = Integer.parse conn.params[:pipeline_id]
    task = %Task{name: conn.params[:name],
      pipeline_id: pipeline_id}
    task = Repo.create task
    redirect conn, to: "/manage/pipeline/#{pipeline_id}"
  end
end
