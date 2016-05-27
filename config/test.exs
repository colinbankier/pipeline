use Mix.Config

config :pipeline_app,
  working_directory: Path.join(File.cwd!, "_test")

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :pipeline_app, PipelineApp.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :pipeline_app, PipelineApp.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "pipeline_app_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
