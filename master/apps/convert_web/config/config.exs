# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :convert_web, namespace: ConvertWeb

# Configures the endpoint
config :convert_web, ConvertWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "fPCdxBqc6CwVleZ6kN/qor4niDpKGMkWFakdWgPxtS5xti7m80c1A1/QNRhKQgMr",
  render_errors: [view: ConvertWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: ConvertWeb.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
# config :logger, :console,
#   format: "$time $metadata[$level] $message\n",
#   metadata: [:request_id]

config :convert_web, :generators, context_app: :convert

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
