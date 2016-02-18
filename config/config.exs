# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :andromeda, Andromeda.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "yWc7xtr2Hu+egeNJUgmB4LGm08acwzMTcfXJM/254BwnhPqOvTNxnSEdeE/Xn4VU",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: Andromeda.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :andromeda,
  scope: "characterLocationRead characterLocationWrite characterFittingsWrite"

config :guardian, Guardian,,
        issuer: "Andromeda",
        ttl: { 20, :hours },
        verify_issuer: true, # optional
        secret_key: "PWRDjzEkJdw48BsgdNyzHGF6Atvb6HCtxLj95aDU",
        serializer: Andromeda.GuardianSerializer

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
