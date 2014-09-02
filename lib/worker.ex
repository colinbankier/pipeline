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
    {:reserved, id, {beanstalk_id, job_id}} = ElixirTalk.reserve(pid)
    TaskRunner.run String.to_integer(job_id)
    deleted = ElixirTalk.delete(pid, id)

    read_job_queue
  end
end
