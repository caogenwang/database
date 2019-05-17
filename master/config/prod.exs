use Mix.Config

config :logger,
  backends: [:console, {LoggerFileBackend, :dev_backend}],
  level: :info,
  format: "$time $metadata[$level] $message\n"

config :logger, :dev_backend,
  level: :warn,
  path: "/System/logs"
