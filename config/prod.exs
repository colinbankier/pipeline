use Mix.Config

# NOTE: To get SSL working, you will need to set:
#
#     ssl: true,
#     keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#     certfile: System.get_env("SOME_APP_SSL_CERT_PATH"),
#
# Where those two env variables point to a file on disk
# for the key and cert

config :phoenix, Pipeline.Router,
  port: System.get_env("PORT"),
  ssl: false,
  host: "example.com",
  cookies: true,
  session_key: "_pipeline_key",
  session_secret: "H9UID65N351$18_HK3W54(7SL4Z$Y7+=1PBFC0D0@9XK%P3@*S4O)NVJ72YF(7DY#%E"

config :logger, :console,
  level: :info,
  metadata: [:request_id]

