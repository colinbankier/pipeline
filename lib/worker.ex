defmodule Worker do
  use GenServer
  alias Models.Job

  def start_link() do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  #####
  # GenServer implementation
  def init(args) do
    IO.puts "Starting worker"
    Task.start_link(__MODULE__, :read_job_queue, [])
    {:ok, nil}
  end

  def read_job_queue do
    {:ok, pid} = ElixirTalk.connect()
    {:reserved, id, {job_id, json}} = ElixirTalk.reserve(pid)
    IO.inspect parse_job(json)
    deleted = ElixirTalk.delete(pid, id)
    read_job_queue
  end

  def parse_job json do
    {:ok, map} = JSEX.decode json
    %Job{
      path: map["path"],
      status: map["status"],
      build_number: map["build_number"],
      run_number: map["run_number"],
      pipeline_json: map["pipeline_json"]
    }
  end
end
