use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :parklot_rsvp, ParklotRsvpWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :parklot_rsvp, ParklotRsvp.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "parklot_rsvp_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :parklot_rsvp, ParklotRsvp.Mailer,
  adapter: Bamboo.TestAdapter
