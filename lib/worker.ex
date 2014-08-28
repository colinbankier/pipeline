defmodule Worker do
  use GenServer

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
    {:reserved, id, json} = ElixirTalk.reserve(pid)
    IO.inspect json
    deleted = ElixirTalk.delete(pid, id)
    IO.inspect deleted
    read_job_queue
  end
end
