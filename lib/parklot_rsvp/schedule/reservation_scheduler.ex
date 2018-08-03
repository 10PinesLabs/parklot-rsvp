defmodule ParklotRsvp.Schedule.ReservationScheduler do

  alias ParklotRsvp.Schedule.Reservation
  alias ParklotRsvp.Schedule.ReservationBestCandidate
  alias ParklotRsvp.Schedule
  alias ParklotRsvp.Mailer
  alias ParklotRsvpWeb.ReservationEmail
  alias ParklotRsvp.Schedule.NoReservationsAvailableError

  def schedule_next_reservation do
    try do
      {:ok, confirmed_reservation} = ReservationBestCandidate.get_best_reservation_candidate_at(tomorrow())
        |> Schedule.confirm_reservation

      confirmed_reservation
        |> send_email_to_users_with_reservation
        |> notify_slack_channel
        |> add_event_to_calendar
    rescue
      NoReservationsAvailableError ->
        #notify_slack_channel_no_reservation
        %Reservation{}
    end
  end

  defp notify_slack_channel(confirmed_reservation) do
    #TODO: Implement ME
    confirmed_reservation
  end

  defp add_event_to_calendar(confirmed_reservation) do
    #TODO: Implement ME
    confirmed_reservation
  end

  defp send_email_to_users_with_reservation(confirmed_reservation) do
    ReservationEmail.reservation_confirmed_email(users_with_reservation_emails(), confirmed_reservation)
      |> Mailer.deliver_now
    confirmed_reservation
  end

  defp users_with_reservation_emails do
    Schedule.get_reservations_by_date(tomorrow()) |> Reservation.users_emails_for
  end

  defp tomorrow do
    Timex.shift(Timex.to_date(Timex.now("America/Buenos_Aires")), days: 1)
  end
end
