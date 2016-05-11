use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
config :pipeline_app, PipelineApp.Endpoint,
  secret_key_base: "hypzYBSD1QzVFMpgJITiBtiRCHSDwzA1eDhn9Nb+CrL+qHXFCqj6EiptmD2hELX1"

# Configure your database
config :pipeline_app, PipelineApp.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "pipeline_app_prod",
  pool_size: 20
