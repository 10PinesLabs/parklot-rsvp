defmodule ParklotRsvp.ScheduleTest do
  use ParklotRsvp.DataCase

  alias ParklotRsvp.Schedule

  describe "reservations" do
    alias ParklotRsvp.Schedule.Reservation

    @valid_attrs %{notes: "some notes", scheduled_at: ~D[2010-04-17], user: "some user"}
    @valid_attrs_without_notes %{scheduled_at: ~D[2010-04-17], user: "some user"}
    @update_attrs %{notes: "some updated notes", scheduled_at: ~D[2011-05-18], user: "some updated user", work_related: false}
    @invalid_attrs %{notes: nil, scheduled_at: nil, user: nil, work_related: nil}

    def reservation_fixture(attrs \\ %{}) do
      {:ok, reservation} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Schedule.create_reservation()

      reservation
    end

    test "list_reservations/0 returns all reservations" do
      reservation = reservation_fixture()
      assert Schedule.list_reservations() == [reservation]
    end

    test "get_reservation!/1 returns the reservation with given id" do
      reservation = reservation_fixture()
      assert Schedule.get_reservation!(reservation.id) == reservation
    end

    test "create_reservation/1 with valid data and notes creates a reservation work related" do
      assert {:ok, %Reservation{} = reservation} = Schedule.create_reservation(@valid_attrs)
      assert reservation.notes == "some notes"
      assert reservation.scheduled_at == ~D[2010-04-17]
      assert reservation.user == "some user"
      assert reservation.work_related == true
    end

    test "create_reservation/1 with valid data without creates a reservation not work related" do
      assert {:ok, %Reservation{} = reservation} = Schedule.create_reservation(@valid_attrs_without_notes)
      assert reservation.notes == nil
      assert reservation.scheduled_at == ~D[2010-04-17]
      assert reservation.user == "some user"
      assert reservation.work_related == false
    end

    test "create_reservation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Schedule.create_reservation(@invalid_attrs)
    end

    test "update_reservation/2 with valid data updates the reservation" do
      reservation = reservation_fixture()
      assert {:ok, reservation} = Schedule.update_reservation(reservation, @update_attrs)
      assert %Reservation{} = reservation
      assert reservation.notes == "some updated notes"
      assert reservation.scheduled_at == ~D[2011-05-18]
      assert reservation.user == "some updated user"
      assert reservation.work_related == true
    end

    test "update_reservation/2 with invalid data returns error changeset" do
      reservation = reservation_fixture()
      assert {:error, %Ecto.Changeset{}} = Schedule.update_reservation(reservation, @invalid_attrs)
      assert reservation == Schedule.get_reservation!(reservation.id)
    end

    test "delete_reservation/1 deletes the reservation" do
      reservation = reservation_fixture()
      assert {:ok, %Reservation{}} = Schedule.delete_reservation(reservation)
      assert_raise Ecto.NoResultsError, fn -> Schedule.get_reservation!(reservation.id) end
    end

    test "change_reservation/1 returns a reservation changeset" do
      reservation = reservation_fixture()
      assert %Ecto.Changeset{} = Schedule.change_reservation(reservation)
    end
  end
end
