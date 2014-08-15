ExUnit.start

defmodule Pipeline.TestCase do
  use ExUnit.CaseTemplate

  # Enable code reloading on test cases
  setup do
    :ok
  end
end

defmodule Pipeline.TestHelper do
  alias Pipeline.Models.Pipeline, as: DbPipeline
  alias Domain.Pipeline
  alias Domain.Task

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

  def simple_db_pipeline do
    pipeline = %DbPipeline{name: "Simple Pipeline"}
    pipeline = Repo.insert pipeline
    task_1 = Repo.insert %DbPipeline{
      name: "task 1",
      command: "echo 1",
      pipeline_id: pipeline.id
    }
    task_2 = Repo.insert %DbPipeline{
      name: "task 2",
      pipeline_id: pipeline.id
    }
    task_2a = Repo.insert %DbPipeline{
      name: "task 2a",
      command: "echo 2a",
      pipeline_id: task_2.id
    }
    task_2b = Repo.insert %DbPipeline{
      name: "task 2b",
      command: "echo 2b",
      pipeline_id: task_2.id
    }
    task_2c = Repo.insert %DbPipeline{
      name: "task 2c",
      command: "echo 2c",
      pipeline_id: task_2.id
    }
    task_3 = Repo.insert %DbPipeline{
      name: "task 3",
      command: "echo 3",
      pipeline_id: pipeline.id
    }
    pipeline
  end
end
