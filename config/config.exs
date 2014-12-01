# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the router
config :phoenix, Pipeline.Router,
  url: [host: "localhost"],
  http: [port: System.get_env("PORT")],
  secret_key_base: "204T5O49W4yhh2aDb9WjCiKA8GvGCU1taoSZaXP8i+CbnGqvZPDyNehy3c+/ENhwqHEnt4WL3pS9rq04UVFMrQ==",
  debug_errors: false,
  error_controller: Pipeline.PageController

# Session configuration
config :phoenix, Pipeline.Router,
  session: [store: :cookie,
            key: "_pipeline_key"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
