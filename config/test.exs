use Mix.Config

config :phoenix, Pipeline.Router,
  port: System.get_env("PORT") || 4001,
  ssl: false,
  cookies: true,
  consider_all_requests_local: true,
  session_key: "_pipeline_key",
  session_secret: "H9UID65N351$18_HK3W54(7SL4Z$Y7+=1PBFC0D0@9XK%P3@*S4O)NVJ72YF(7DY#%E"

config :phoenix, :code_reloader,
  enabled: true

config :logger, :console,
  level: :debug


