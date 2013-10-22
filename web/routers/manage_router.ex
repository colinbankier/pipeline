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
    IO.puts "Created. #{conn.params[:name]}"
    redirect conn, to: "/manage/pipeline/#{conn.params[:name]}"
  end

  get "pipeline/:name" do
    conn = conn.assign(:name, conn.params[:name])
    render conn, "manage/pipeline/show.html"
  end
end
