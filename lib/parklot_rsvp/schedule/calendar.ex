defmodule ParklotRsvp.Schedule.Calendar do
  alias GoogleApi.Calendar.V3.Model.Event

  require Logger


  @calendar_id System.get_env("GOOGLE_CALENDAR_ID")
  def create_event(reservation) do
    event = %Event{
      description: "Cochera #{reservation.user}",
      summary: "Cochera #{reservation.user}",
      visibility: "public",
      status: "confirmed",
      start: %GoogleApi.Calendar.V3.Model.EventDateTime{
        date: reservation.scheduled_at,
      },
      end: %GoogleApi.Calendar.V3.Model.EventDateTime{
        date: reservation.scheduled_at,
      }
    }

    params = [body: event]
    Logger.debug inspect(params)

    conn =
      get_token()
      |> connection().new

    result = api().calendar_events_insert(conn, @calendar_id, params)

    case result do
      {:ok, event} -> Logger.info inspect(event)
      {:error, info} -> Logger.error inspect(info)
    end
    reservation
  end

  defp connection do
    Application.get_env(:parklot_rsvp, :google_connection)
  end

  defp api do
    Application.get_env(:parklot_rsvp, :google_api)
  end

  defp token do
    Application.get_env(:parklot_rsvp, :google_token_provider)
  end

  defp get_token do
    {:ok, token} = token().for_scope("https://www.googleapis.com/auth/calendar")
    token.token
  end
end
