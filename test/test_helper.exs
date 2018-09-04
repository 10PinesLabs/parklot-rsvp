ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(ParklotRsvp.Repo, :manual)

Mox.defmock(
  Http.Mock,
  for: Http.Behaviour
)

Mox.defmock(ParklotRsvp.Schedule.GoogleConnectionMock, for: Http.GoogleBehaviour.Connection)
Mox.defmock(ParklotRsvp.Schedule.GoogleApiMock, for: Http.GoogleBehaviour.Api)
Mox.defmock(ParklotRsvp.Schedule.TokenMock, for: Http.GoogleBehaviour.TokenProvider)
