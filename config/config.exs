# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :ph2, Ph2.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "8MFZ0sqZrsu7szmYS0LmndbzaGf9k9321wR7Qbdag/VzjMxsLO8jBOgMezV+q92I",
  render_errors: [accepts: ~w(html json)],
  #pubsub: [name: Ph2.PubSub, adapter: Phoenix.PubSub.PG2]
  pubsub: [name: Ph2.PubSub, adapter: Phoenix.PubSub.Redis, host: "127.0.0.1"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false
