use Mix.Config

config :phoenix, Pipline.Router,
  http: [port: System.get_env("PORT") || 4001],
