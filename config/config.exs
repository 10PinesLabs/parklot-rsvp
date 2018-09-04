# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :parklot_rsvp,
  ecto_repos: [ParklotRsvp.Repo]

# Configures the endpoint
config :parklot_rsvp, ParklotRsvpWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "SXDbSNWaCLMMY3NIB1NRK8DZtIzSYYP1YBDpOsEYSywpJzzl2/i8eP8dhWberRnG",
  render_errors: [view: ParklotRsvpWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: ParklotRsvp.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

config :parklot_rsvp, ParklotRsvp.Mailer,
  adapter: Bamboo.SMTPAdapter,
  server: System.get_env("SMTP_SERVER"),
  port: System.get_env("SMTP_PORT"),
  username: System.get_env("SMTP_USERNAME"),
  password: System.get_env("SMTP_PASSWORD"),
  tls: :if_available, # can be `:always` or `:never`
  ssl: true, # can be `true`
  retries: 1

config :parklot_rsvp, :http_adapter, HTTPoison

config :parklot_rsvp, :google_connection, GoogleApi.Calendar.V3.Connection
config :parklot_rsvp, :google_token_provider, Goth.Token
config :parklot_rsvp, :google_api, GoogleApi.Calendar.V3.Api.Events

#config(:goth, :json, {:system, "GOOGLE_APP_CREDENTIALS_CONTENT"} )

config(:goth, :json, "{
  \"type\": \"service_account\",
  \"project_id\": \"parklot-rsvp\",
  \"private_key_id\": \"#{System.get_env("GOOGLE_PRIVATE_KEY_ID")}\",
  \"private_key\": \"#{System.get_env("GOOGLE_PRIVATE_KEY")}\",
  \"client_email\": \"#{System.get_env("GOOGLE_CLIENT_EMAIL")}\",
  \"client_id\": \"#{System.get_env("GOOGLE_CLIENT_ID")}\",
  \"auth_uri\": \"https://accounts.google.com/o/oauth2/auth\",
  \"token_uri\": \"https://oauth2.googleapis.com/token\",
  \"auth_provider_x509_cert_url\": \"https://www.googleapis.com/oauth2/v1/certs\",
  \"client_x509_cert_url\": \"https://www.googleapis.com/robot/v1/metadata/x509/parklot-rsvp%40parklot-rsvp.iam.gserviceaccount.com\"
}")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
