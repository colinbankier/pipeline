ExUnit.start

# Create the database, run migrations, and start the test transaction.
Mix.Task.run "ecto.create", ["--quiet"]
Mix.Task.run "ecto.migrate", ["--quiet"]
Ecto.Adapters.SQL.begin_test_transaction(Pipeline.Repo)

defmodule Pipeline.TestHelper do
  alias Pipeline.Repo
  alias Pipeline.TaskScheduler
  alias Domain.Pipeline
  alias Domain.Task
  alias Models.Job

  @wait_interval 200

  def wait_for(function) do
    wait_for function, 5000
  end

  def wait_for(function, time) do
    if !function.() do
      IO.puts "Assert polling..."
      :timer.sleep @wait_interval
      wait_for(function, time - @wait_interval)
    end
    :ok
  end

  def wait_for(_, time) when time <= 0 do
    :timed_out
  end

  def create_job pipeline = %Pipeline{}, path do
    build = TaskScheduler.create_build(pipeline)
    TaskScheduler.create_job(pipeline, path, build)
    |> Repo.insert
  end

  def run_task pipeline_json, path do
    job = create_job(simple_pipeline_json, path)
    TaskRunner.run job.id
    Repo.get(Job, job.id)
  end

  def simple_task_json do
    """
      { "name": "task 1", "command": "echo 1" }
    """
  end

  def simple_pipeline_json do
     """
    { "name": "Simple Pipeline",
    "tasks": [
    { "name": "task 1", "command": "echo 1" },
    { "name": "task 2",
    "tasks": [
    { "name": "task 2a", "command": "echo 2a" },
    { "name": "task 2b", "command": "echo 2b" },
    { "name": "task 2c", "command": "echo 2c" }
    ]
    },
    { "name": "task 3", "command": "echo 3" }
    ]
    }
    """
  end

  def simple_pipeline do
    %Pipeline{name: "Simple Pipeline",
    tasks: [
      %Task{name: "task 1", command: "echo 1"},
      %Pipeline{name: "task 2",
      tasks: [
        %Task{name: "task 2a", command: "echo 2a" },
        %Task{name: "task 2b", command: "echo 2b" },
        %Task{name: "task 2c", command: "echo 2c" },
        ]
      },
      %Task{name: "task 3", command: "echo 3"},
      ]
    }
  end
end
