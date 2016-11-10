# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :gamedex,
  ecto_repos: [Gamedex.Repo]

# Configures the endpoint
config :gamedex, Gamedex.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "aDwtNrD91KXi0f68jNfVcBGo5KEeuty/3wARi8rtOcj1J5vr/KYtINoCgOZQHmou",
  render_errors: [view: Gamedex.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Gamedex.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :ueberauth, Ueberauth,
  base_path: "/login", # default is "/auth"
  providers: [
    identity: {Ueberauth.Strategies.Identity, [request_path: "/login/identity",
                                               callback_path: "/login/identity/callback"]}
  ]

config :guardian, Guardian,
  issuer: "Gamedev.#{Mix.env}",
  ttl: {30, :days},
  verify_issuer: true,
  serializer: Gamedex.GuardianSerializer,
  secret_key: to_string(Mix.env),
  hooks: GuardianDb,
  permissions: %{
    default: [
      :read_profile,
      :write_profile,
      :read_token,
      :revoke_token,
    ],
  }


config :guardian_db, GuardianDb,
  repo: PhoenixGuardian.Repo,
  sweep_interval: 60 # 60 minutes

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
