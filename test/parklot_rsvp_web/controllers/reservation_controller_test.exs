defmodule ParklotRsvpWeb.ReservationControllerTest do
  use ParklotRsvpWeb.ConnCase

  alias ParklotRsvp.Schedule
  alias ParklotRsvp.Schedule.Reservation

  @create_attrs %{notes: "some notes", scheduled_at: "2010-04-17", user: "some user", work_related: false}
  @create_from_slack_attrs %{"text" => "reservar el 17-04-2010", "user_name" => "some user"}
  @show_from_slack_attrs %{"text" => "mostrar el 17-04-2010", "user_name" => "some user"}
  @create_from_slack_with_notes_attrs %{"text" => "reservar el 17-04-2010 por visita cliente", "user_name" => "some user"}
  @cancel_from_slack %{"text" => "cancelar el 17-04-2010", "user_name" => "some user"}
  @update_attrs %{notes: "some updated notes", scheduled_at: ~D[2011-05-18], user: "some updated user", work_related: false}
  @invalid_attrs %{notes: nil, scheduled_at: nil, user: nil, work_related: nil}

  def fixture(:reservation) do
    {:ok, reservation} = Schedule.create_reservation(@create_attrs)
    reservation
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all reservations", %{conn: conn} do
      conn = get conn, reservation_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "show reservation" do
    setup [:create_reservation]

    test "from slack renders reservation", %{conn: conn, reservation: reservation} do
      conn = post conn, reservation_path(conn, :run_from_slack), @show_from_slack_attrs
      all_reservations = [%{
        "id" => reservation.id,
        "notes" => "some notes",
        "scheduled_at" => "2010-04-17",
        "user" => "some user",
        "confirmed" => false,
        "work_related" => true}]

      assert json_response(conn, 200)["data"] == all_reservations
    end
  end

  describe "create reservation" do
    test "renders reservation when data is valid", %{conn: conn} do
      conn = post conn, reservation_path(conn, :create), reservation: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, reservation_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "notes" => "some notes",
        "scheduled_at" => "2010-04-17",
        "user" => "some user",
        "confirmed" => false,
        "work_related" => true}
    end

    test "from slack renders reservation when data is valid", %{conn: conn} do
      conn = post conn, reservation_path(conn, :run_from_slack), @create_from_slack_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, reservation_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "notes" => nil,
        "scheduled_at" => "2010-04-17",
        "user" => "some user",
        "confirmed" => false,
        "work_related" => false}
    end

    test "from slack renders reservation when data is valid and is work related", %{conn: conn} do
      conn = post conn, reservation_path(conn, :run_from_slack), @create_from_slack_with_notes_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, reservation_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "notes" => "visita cliente",
        "scheduled_at" => "2010-04-17",
        "user" => "some user",
        "confirmed" => false,
        "work_related" => true}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, reservation_path(conn, :create), reservation: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update reservation" do
    setup [:create_reservation]

    test "renders reservation when data is valid", %{conn: conn, reservation: %Reservation{id: id} = reservation} do
      conn = put conn, reservation_path(conn, :update, reservation), reservation: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, reservation_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "notes" => "some updated notes",
        "scheduled_at" => "2011-05-18",
        "user" => "some updated user",
        "confirmed" => false,
        "work_related" => true}
    end

    test "renders errors when data is invalid", %{conn: conn, reservation: reservation} do
      conn = put conn, reservation_path(conn, :update, reservation), reservation: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete reservation" do
    setup [:create_reservation]

    test "deletes chosen reservation", %{conn: conn, reservation: reservation} do
      conn = delete conn, reservation_path(conn, :delete, reservation)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, reservation_path(conn, :show, reservation)
      end
    end

    test "cancels reservation by user and date", %{conn: conn, reservation: reservation} do
      conn = post conn, reservation_path(conn, :run_from_slack), @cancel_from_slack
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, reservation_path(conn, :show, reservation)
      end
    end
  end

  defp create_reservation(_) do
    reservation = fixture(:reservation)
    {:ok, reservation: reservation}
  end
end
