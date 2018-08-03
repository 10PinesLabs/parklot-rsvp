defmodule ParklotRsvpWeb.ReservationController do
  use ParklotRsvpWeb, :controller

  alias ParklotRsvp.Schedule
  alias ParklotRsvp.Schedule.Reservation
  alias ParklotRsvp.Schedule.ReservationScheduler

  action_fallback ParklotRsvpWeb.FallbackController

  import ParklotRsvpWeb.SlackInputParser

  def index(conn, _params) do
    reservations = Schedule.list_reservations()
    render(conn, "index.json", reservations: reservations)
  end

  def run_from_slack(conn, params) do
    slack_command(conn, parse_create_reservation_params(params))
  end

  def slack_command(conn, params = %{command: "reservar"}) do
    create(conn, %{"reservation" => params})
  end

  def slack_command(conn, params = %{command: "cancelar"}) do
    delete_reservation(conn, Schedule.get_reservation_by_user_and_date!(params[:user], params[:scheduled_at]))
  end

  def slack_command(conn, params = %{command: "mostrar"}) do
    reservations = Schedule.get_reservations_by_date(params[:scheduled_at])
    render(conn, "index.json", reservations: reservations)
  end

  def confirm_reservation(conn, _params) do
    confirmed_reservation = ReservationScheduler.schedule_next_reservation()
    render(conn, "show.json", reservation: confirmed_reservation)
  end

  def create(conn, %{"reservation" => reservation_params}) do
    with {:ok, %Reservation{} = reservation} <- Schedule.create_reservation(reservation_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", reservation_path(conn, :show, reservation))
      |> render("show.json", reservation: reservation)
    end
  end

  def show(conn, %{"id" => id}) do
    reservation = Schedule.get_reservation!(id)
    render(conn, "show.json", reservation: reservation)
  end

  def update(conn, %{"id" => id, "reservation" => reservation_params}) do
    reservation = Schedule.get_reservation!(id)

    with {:ok, %Reservation{} = reservation} <- Schedule.update_reservation(reservation, reservation_params) do
      render(conn, "show.json", reservation: reservation)
    end
  end

  def delete(conn, %{"id" => id}) do
    delete_reservation(conn, Schedule.get_reservation!(id))
  end

  defp delete_reservation(conn, reservation) do
    with {:ok, %Reservation{}} <- Schedule.delete_reservation(reservation) do
      send_resp(conn, :no_content, "")
    end
  end
end
