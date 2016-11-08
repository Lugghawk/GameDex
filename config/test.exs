use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :gamedex, Gamedex.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :gamedex, Gamedex.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "gamedex_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
