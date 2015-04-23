use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
config :pipeline, Pipeline.Endpoint,
  secret_key_base: "n3wZKBjw3qPxg1iic+vOpNjhOO4Mxy3fTaFdQ6g3iqs4dbSb3UT0FrlOmITU7T3x"

# Configure your database
config :pipeline, Pipeline.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "pipeline_prod"
