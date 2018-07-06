defmodule ParklotRsvpWeb.ReservationView do
  use ParklotRsvpWeb, :view
  alias ParklotRsvpWeb.ReservationView

  def render("index.json", %{reservations: reservations}) do
    %{data: render_many(reservations, ReservationView, "reservation.json")}
  end

  def render("show.json", %{reservation: reservation}) do
    %{data: render_one(reservation, ReservationView, "reservation.json")}
  end

  def render("reservation.json", %{reservation: reservation}) do
    %{id: reservation.id,
      user: reservation.user,
      scheduled_at: reservation.scheduled_at,
      work_related: reservation.work_related,
      notes: reservation.notes}
  end
end
