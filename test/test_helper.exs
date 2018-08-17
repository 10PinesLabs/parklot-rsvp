ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(ParklotRsvp.Repo, :manual)

Mox.defmock(
  Http.Mock,
  for: Http.Behaviour
)
