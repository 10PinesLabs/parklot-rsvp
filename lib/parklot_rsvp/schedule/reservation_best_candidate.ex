defmodule ParklotRsvp.Schedule.ReservationBestCandidate do

  import ParklotRsvp.Schedule, warn: false
  alias ParklotRsvp.Schedule.Reservation
  alias ParklotRsvp.Schedule.NoReservationsAvailableError

  @days_ago 30

  def get_best_reservation_candidate_at(a_date) do
    reservations = get_reservations_by_date(a_date)
      |> fetch_work_related_or_all

    Reservation.users_for(reservations)
      |> get_usage_by_users(@days_ago)
      |> best_reservation_candidate(reservations)
  end

  def fetch_work_related_or_all(reservations) do
    work_related_reservations = Enum.filter(reservations, &Reservation.work_related?/1)
    if Enum.empty?(work_related_reservations), do: reservations, else: work_related_reservations
  end

  def best_reservation_candidate(usage, reservations) do
    try do
      Enum.group_by(reservations, group_by_key(usage))
      |> Enum.min
      |> elem(1)
      |> Enum.random
    rescue
      Enum.EmptyError -> raise NoReservationsAvailableError
    end
  end

  def group_by_key(usage) do
    fn(reservation) ->
      {_, user_usage, last_usage_at} = Enum.find(usage, {reservation.user, 0, Timex.epoch}, fn(u) -> elem(u, 0) == reservation.user end)

      secs = Integer.to_string(DateTime.to_unix(Timex.to_datetime(last_usage_at)))

      key = user_usage
        |> Integer.to_string
        |> String.pad_leading(3, "0")

      "#{key}_#{secs}"
    end
  end
end
