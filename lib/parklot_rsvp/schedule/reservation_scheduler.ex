defmodule ParklotRsvp.Schedule.ReservationScheduler do

  alias ParklotRsvp.Schedule.Reservation
  alias ParklotRsvp.Schedule.ReservationBestCandidate
  alias ParklotRsvp.Schedule
  alias ParklotRsvp.Mailer
  alias ParklotRsvpWeb.ReservationEmail
  alias ParklotRsvp.Schedule.NoReservationsAvailableError
  alias ParklotRsvp.Slack.SlackCallbackWrapper

  def schedule_next_reservation do
    schedule_next_reservation(tomorrow())
  end

  def schedule_next_reservation(a_date) do
    try do
      {:ok, confirmed_reservation} = ReservationBestCandidate.get_best_reservation_candidate_at(a_date)
        |> Schedule.confirm_reservation

      confirmed_reservation
        |> send_email_to_users_with_reservation(a_date)
        |> notify_slack_channel
        |> add_event_to_calendar
    rescue
      NoReservationsAvailableError ->
        notify_slack_channel_no_reservation(a_date)
        %Reservation{}
    end
  end

  defp notify_slack_channel_no_reservation(a_date) do
    SlackCallbackWrapper.send_no_reservation_callback(a_date)
  end

  defp notify_slack_channel(confirmed_reservation) do
    SlackCallbackWrapper.send_reservation_callback(confirmed_reservation)
    confirmed_reservation
  end

  defp add_event_to_calendar(confirmed_reservation) do
    #TODO: Implement ME
    confirmed_reservation
  end

  defp send_email_to_users_with_reservation(confirmed_reservation, a_date) do
    ReservationEmail.reservation_confirmed_email(users_with_reservation_emails(a_date), confirmed_reservation)
      |> Mailer.deliver_now
    confirmed_reservation
  end

  defp users_with_reservation_emails(a_date) do
    Schedule.get_reservations_by_date(a_date) |> Reservation.users_emails_for
  end

  defp tomorrow do
    Timex.shift(Timex.to_date(Timex.now("America/Buenos_Aires")), days: 1)
  end
end
