# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :elixir_microserver,
  ecto_repos: [ElixirMicroserver.Repo]

# Configures the endpoint
config :elixir_microserver, ElixirMicroserverWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "BtEbVktHqR0Lg6YbRGGGjm+0CL4Wob1b1ScMIx3yTwWHMG5bi4IcewCZy30VGCoa",
  render_errors: [view: ElixirMicroserverWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: ElixirMicroserver.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
