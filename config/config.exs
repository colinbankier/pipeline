use Mix.Config

config :phoenix, Pipeline.Router,
  port: System.get_env("PORT"),
  ssl: false,
  code_reload: false,
  cookies: true,
  session_key: "sdfsdfd_your_app_keysomethingreallylongandsecresdfsdfsdfsdfsdfsdfsdft",
  session_secret: "super secret, no really, really secret sdfsdfsdfsdfsdfsdfsdfsdfsdfsdfds"

config :phoenix, :logger,
  level: :error


import_config "#{Mix.env}.exs"
