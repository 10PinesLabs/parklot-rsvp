defmodule ParklotRsvp.Schedule.ReservationBestCandidateTest do
  use ParklotRsvp.DataCase
  use ExMatchers

  import ParklotRsvp.Fixtures #, [:reservation_fixture]

  alias ParklotRsvp.Schedule.ReservationBestCandidate
  alias ParklotRsvp.Schedule.NoReservationsAvailableError

  describe "best reservation candidate" do

    test "fetch_confirmed_or_all when no work related" do
      reservations = [reservation_fixture(%{user: "john", notes: nil})]
        |> Enum.concat([reservation_fixture(%{user: "paul", notes: nil})])
        |> Enum.concat([reservation_fixture(%{user: "george", notes: nil})])
        |> Enum.concat([reservation_fixture(%{user: "ringo", notes: nil})])

        work_related_or_all = ReservationBestCandidate.fetch_work_related_or_all(reservations)

        expect length(work_related_or_all), to: eq(4)
    end

    test "fetch_confirmed_or_all when some work related" do
      paul_reservation = work_related_reservation_fixture(%{user: "paul"})
      ringo_reservation = work_related_reservation_fixture(%{user: "ringo"})
      reservations = [reservation_fixture(%{user: "john", notes: nil})]
        |> Enum.concat([paul_reservation])
        |> Enum.concat([reservation_fixture(%{user: "george", notes: nil})])
        |> Enum.concat([ringo_reservation])

        work_related_or_all = ReservationBestCandidate.fetch_work_related_or_all(reservations)

        expect length(work_related_or_all), to: eq(2)
        expect work_related_or_all, to: include(paul_reservation)
        expect work_related_or_all, to: include(ringo_reservation)
    end

    test "best reservation candidate when no tie" do
      three_days_ago = Timex.shift(Timex.today, days: -3)

      usage = [{"george", 1, three_days_ago}, {"john", 3, three_days_ago}, {"paul", 2, three_days_ago}]

      ringo_reservation = reservation_fixture(%{user: "ringo", notes: nil})
      reservations = [reservation_fixture(%{user: "john", notes: nil})]
        |> Enum.concat([reservation_fixture(%{user: "paul", notes: nil})])
        |> Enum.concat([reservation_fixture(%{user: "george", notes: nil})])
        |> Enum.concat([ringo_reservation])

      best_candidate = ReservationBestCandidate.best_reservation_candidate(usage, reservations)

      expect best_candidate, to: eq(ringo_reservation)
    end

    test "best reservation candidate when tie select least recent" do
      yesterday = Timex.shift(Timex.today, days: -1)
      two_days_ago = Timex.shift(Timex.today, days: -2)
      three_days_ago = Timex.shift(Timex.today, days: -3)

      usage = [{"george", 1, three_days_ago}, {"john", 3, yesterday}, {"ringo", 1, two_days_ago}, {"paul", 2, yesterday}]

      george_reservation = reservation_fixture(%{user: "george", notes: nil})

      reservations = [reservation_fixture(%{user: "john", notes: nil})]
        |> Enum.concat([reservation_fixture(%{user: "paul", notes: nil})])
        |> Enum.concat([george_reservation])
        |> Enum.concat([reservation_fixture(%{user: "ringo", notes: nil})])

      best_candidate = ReservationBestCandidate.best_reservation_candidate(usage, reservations)
      expect best_candidate, to: eq(george_reservation)
    end

    test "best reservation candidate when tie select random" do
      three_days_ago = Timex.shift(Timex.today, days: -3)
      usage = [{"george", 1, three_days_ago}, {"john", 3, three_days_ago}, {"ringo", 1, three_days_ago}, {"paul", 2, three_days_ago}]

      reservations = [reservation_fixture(%{user: "john", notes: nil})]
        |> Enum.concat([reservation_fixture(%{user: "paul", notes: nil})])
        |> Enum.concat([reservation_fixture(%{user: "george", notes: nil})])
        |> Enum.concat([reservation_fixture(%{user: "ringo", notes: nil})])

      best_candidate = ReservationBestCandidate.best_reservation_candidate(usage, reservations)

      expect ["ringo", "george"], to: include(best_candidate.user)
    end

    test "get best reservation candidate at date when no reservations found" do
      get_best_reservation_candidate = fn() -> ReservationBestCandidate.get_best_reservation_candidate_at(~D[2010-04-17]) end

      expect get_best_reservation_candidate, to: raise_error(NoReservationsAvailableError)
    end

    test "get best reservation candidate at date" do
      reservation_fixture(%{user: "john", notes: nil})
      reservation_fixture(%{user: "paul", notes: nil})
      reservation_fixture(%{user: "george", notes: nil})
      reservation_fixture(%{user: "ringo", notes: "work related"})

      best_reservation = ReservationBestCandidate.get_best_reservation_candidate_at(~D[2010-04-17])

      expect best_reservation.user, to: eq("ringo")
    end
  end

end
