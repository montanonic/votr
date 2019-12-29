# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config

# Configure Mix tasks and generators
config :votr,
  ecto_repos: [Votr.Repo]

config :votr_web,
  ecto_repos: [Votr.Repo],
  generators: [context_app: :votr]

# Configures the endpoint
config :votr_web, VotrWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "JVZA2vHdGYEt3IF+pyGEHMp3NdKnokiWOLvFbG865nzsI37wDY4VrMKGFF69Yn0t",
  render_errors: [view: VotrWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: VotrWeb.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
