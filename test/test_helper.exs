ExUnit.start

Mix.Task.run "ecto.create", ~w(-r PipelineApp.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r PipelineApp.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(PipelineApp.Repo)

