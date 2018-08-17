defmodule ParklotRsvpWeb.ReservationView do
  use ParklotRsvpWeb, :view
  alias ParklotRsvpWeb.ReservationView
  alias ParklotRsvp.Schedule.Reservation

  def render("index.json", %{reservations: reservations}) do
    %{data: render_many(reservations, ReservationView, "reservation.json")}
  end

  def render("show.json", %{reservation: reservation}) do
    %{data: render_one(reservation, ReservationView, "reservation.json")}
  end

  def render("reservation.json", %{reservation: reservation}) do
    Reservation.to_map(reservation)
    # %{id: reservation.id,
    #   user: reservation.user,
    #   scheduled_at: reservation.scheduled_at,
    #   work_related: reservation.work_related,
    #   confirmed: reservation.confirmed,
    #   notes: reservation.notes}
  end
end
