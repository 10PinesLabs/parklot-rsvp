defmodule ParklotRsvp.Schedule.ReservationSchedulerTest do
  use ParklotRsvp.DataCase
  use ExMatchers

  import ParklotRsvp.Fixtures

  alias ParklotRsvp.Schedule.ReservationScheduler

  @tomorrow Timex.shift(Timex.to_date(Timex.now("America/Buenos_Aires")), days: 1)

  test "schedule the next reservation" do
    reservation_fixture(%{user: "john", notes: nil, scheduled_at: @tomorrow})
    reservation_fixture(%{user: "paul", notes: nil, scheduled_at: @tomorrow})
    reservation_fixture(%{user: "george", notes: nil, scheduled_at: @tomorrow})
    reservation_fixture(%{user: "ringo", notes: "work related", scheduled_at: @tomorrow})

    confirmed_reservation = ReservationScheduler.schedule_next_reservation()

    expect confirmed_reservation.confirmed, to: eq(true)
    expect confirmed_reservation.user, to: eq("ringo")
  end

  test "schedule the next reservation sends email" do
    # TODO
  end

  test "schedule the next reservation notifies slack channel" do
    # TODO
  end

  test "schedule the next reservation adds event to calendar" do
    # TODO
  end

  test "nothing to schedule returns empty Schedule" do
    # TODO
  end

  test "nothing to schedule notifies slack channel" do
    # TODO
  end
end
