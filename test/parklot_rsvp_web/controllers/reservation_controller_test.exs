defmodule ParklotRsvpWeb.ReservationControllerTest do
  use ParklotRsvpWeb.ConnCase

  alias ParklotRsvp.Schedule
  alias ParklotRsvp.Schedule.Reservation

  @create_attrs %{notes: "some notes", scheduled_at: ~D[2010-04-17], user: "some user", work_related: true}
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
        "work_related" => false}
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
  end

  defp create_reservation(_) do
    reservation = fixture(:reservation)
    {:ok, reservation: reservation}
  end
end
