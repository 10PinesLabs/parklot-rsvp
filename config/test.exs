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

config :parklot_rsvp, http_adapter: Http.Mock

config :parklot_rsvp, :google_connection, ParklotRsvp.Schedule.GoogleConnectionMock
config :parklot_rsvp, :google_api, ParklotRsvp.Schedule.GoogleApiMock
config :parklot_rsvp, :google_token_provider, ParklotRsvp.Schedule.TokenMock

config(:goth, :json, "{
  \"type\": \"service_account\",
  \"project_id\": \"parklot-rsvp\",
  \"private_key_id\": \"\",
  \"private_key\": \"\",
  \"client_email\": \"\",
  \"client_id\": \"\",
  \"auth_uri\": \"https://accounts.google.com/o/oauth2/auth\",
  \"token_uri\": \"https://oauth2.googleapis.com/token\",
  \"auth_provider_x509_cert_url\": \"https://www.googleapis.com/oauth2/v1/certs\",
  \"client_x509_cert_url\": \"https://www.googleapis.com/robot/v1/metadata/x509/parklot-rsvp%40parklot-rsvp.iam.gserviceaccount.com\"
}")
