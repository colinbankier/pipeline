use Mix.Config

config :phoenix, Pipeline.Router,
  port: System.get_env("PORT") || 4000,
  ssl: false,
  code_reload: true,
  cookies: true,
  consider_all_requests_local: true,
  session_key: "sdfsdfd_your_app_keysomethingreallylongandsecresdfsdfsdfsdfsdfsdfsdft",
  session_secret: "super secret, no really, really secret sdfsdfsdfsdfsdfsdfsdfsdfsdfsdfds"

config :phoenix, :logger,
  level: :debug
