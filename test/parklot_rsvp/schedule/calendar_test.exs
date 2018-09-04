defmodule ParklotRsvp.Schedule.CalendarTest do
  use ParklotRsvp.DataCase
  use ExMatchers
  use Bamboo.Test

  import ParklotRsvp.Fixtures

  alias ParklotRsvp.Schedule.Calendar
  alias GoogleApi.Calendar.V3.Model.Event

  alias ParklotRsvp.Schedule.GoogleApiMock

  import Mox

  @tomorrow Timex.shift(Timex.to_date(Timex.now("America/Buenos_Aires")), days: 1)

  setup do
    ParklotRsvp.Schedule.GoogleConnectionMock
      |> stub(:new, fn _ -> %Tesla.Client{} end )

    ParklotRsvp.Schedule.TokenMock
      |> stub(:for_scope, fn _ -> {:ok, %{token: ""}} end)


    GoogleApiMock
      |> stub(:calendar_events_insert, fn _, _, _ -> {:ok, %Event{}} end)
    :ok
  end

  test "the name is present in the description" do
    reservation = reservation_fixture(%{user: "john", notes: nil, scheduled_at: @tomorrow})

    GoogleApiMock
      |> expect(:calendar_events_insert, fn _, _, [body: event] ->
        assert event.description =~ "john"
        {:ok, %Event{}}
    end)

    Calendar.create_event(reservation)

    verify! GoogleApiMock
  end

  test "the name is present in the summary" do
    reservation = reservation_fixture(%{user: "john", notes: nil, scheduled_at: @tomorrow})

    GoogleApiMock
      |> expect(:calendar_events_insert, fn _, _, [body: event] ->
        assert event.summary =~ "john"
        {:ok, %Event{}}
    end)

    Calendar.create_event(reservation)

    verify! GoogleApiMock
  end

  test "the event status is confirmed" do
    reservation = reservation_fixture(%{user: "john", notes: nil, scheduled_at: @tomorrow})

    GoogleApiMock
      |> expect(:calendar_events_insert, fn _, _, [body: event] ->
        assert event.status == "confirmed"
        {:ok, %Event{}}
    end)

    Calendar.create_event(reservation)

    verify! GoogleApiMock
  end

  test "the event is visible" do
    reservation = reservation_fixture(%{user: "john", notes: nil, scheduled_at: @tomorrow})

    GoogleApiMock
      |> expect(:calendar_events_insert, fn _, _, [body: event] ->
        assert event.visibility == "public"
        {:ok, %Event{}}
    end)

    Calendar.create_event(reservation)

    verify! GoogleApiMock
  end

  test "the event is a whole-day event" do
    reservation = reservation_fixture(%{user: "john", notes: nil, scheduled_at: @tomorrow})

    GoogleApiMock
      |> expect(:calendar_events_insert, fn _, _, [body: event] ->
        assert event.start.date == @tomorrow
        assert event.end.date == @tomorrow
        {:ok, %Event{}}
    end)

    Calendar.create_event(reservation)

    verify! GoogleApiMock
  end

end
