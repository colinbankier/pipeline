use Mix.Config

config :phoenix, Pipeline.Router,
  http: [port: System.get_env("PORT") || 4001],
