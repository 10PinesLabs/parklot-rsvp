defmodule ParklotRsvp.ScheduleTest do
  use ParklotRsvp.DataCase
  use ExMatchers

  import ParklotRsvp.Fixtures

  alias ParklotRsvp.Schedule

  describe "reservations" do
    alias ParklotRsvp.Schedule.Reservation

    test "list_reservations/0 returns all reservations" do
      reservation = reservation_fixture()
      assert Schedule.list_reservations() == [reservation]
    end

    test "get_reservation!/1 returns the reservation with given id" do
      reservation = reservation_fixture()
      assert Schedule.get_reservation!(reservation.id) == reservation
    end

    test "create_reservation/1 with valid data and notes creates a reservation work related" do
      assert {:ok, %Reservation{} = reservation} = Schedule.create_reservation(valid_reservation_attrs())
      assert reservation.notes == "some notes"
      assert reservation.scheduled_at == ~D[2010-04-17]
      assert reservation.user == "some user"
      assert reservation.work_related == true
    end

    test "create_reservation/1 with valid data without notes creates a reservation not work related" do
      assert {:ok, %Reservation{} = reservation} = Schedule.create_reservation(valid_reservation_attrs_without_notes())
      assert reservation.notes == nil
      assert reservation.scheduled_at == ~D[2010-04-17]
      assert reservation.user == "some user"
      assert reservation.work_related == false
    end

    test "create_reservation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Schedule.create_reservation(invalid_reservation_attrs())
    end

    test "update_reservation/2 with valid data updates the reservation" do
      reservation = reservation_fixture()
      assert {:ok, reservation} = Schedule.update_reservation(reservation, update_reservation_attrs())
      assert %Reservation{} = reservation
      assert reservation.notes == "some updated notes"
      assert reservation.scheduled_at == ~D[2011-05-18]
      assert reservation.user == "some updated user"
      assert reservation.work_related == true
    end

    test "update_reservation/2 with invalid data returns error changeset" do
      reservation = reservation_fixture()
      assert {:error, %Ecto.Changeset{}} = Schedule.update_reservation(reservation, invalid_reservation_attrs())
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

    test "confirm a reservation" do
      reservation = reservation_fixture()
      Schedule.confirm_reservation(reservation)

      expect Schedule.get_reservation!(reservation.id).confirmed, to: eq(true)
    end

    test "get_usage_by_user for one user" do
      yesterday = Timex.shift(Timex.today, days: -1)
      tomorrow = Timex.shift(Timex.today, days: 1)
      six_days_ago = Timex.shift(Timex.today, days: 6)
      two_days_ago = Timex.shift(Timex.today, days: -2)

      confirmed_reservation_fixture(%{scheduled_at: tomorrow})
      confirmed_reservation_fixture(%{scheduled_at: yesterday})
      confirmed_reservation_fixture(%{scheduled_at: six_days_ago})
      reservation_fixture(%{scheduled_at: two_days_ago})

      usage = Schedule.get_usage_by_users(["some user"], 5)

      expect usage, to: eq([{"some user", 1, yesterday}])
    end

    test "get_usage_by_user for three user" do
      yesterday = Timex.shift(Timex.today, days: -1)
      three_days_ago = Timex.shift(Timex.today, days: -3)
      two_days_ago = Timex.shift(Timex.today, days: -2)

      confirmed_reservation_fixture(%{scheduled_at: yesterday, user: "john"})
      confirmed_reservation_fixture(%{scheduled_at: yesterday, user: "paul"})
      confirmed_reservation_fixture(%{scheduled_at: three_days_ago, user: "john"})
      confirmed_reservation_fixture(%{scheduled_at: three_days_ago, user: "george"})
      confirmed_reservation_fixture(%{scheduled_at: two_days_ago, user: "paul"})
      confirmed_reservation_fixture(%{scheduled_at: two_days_ago, user: "john"})

      usage = Schedule.get_usage_by_users(["john", "george", "paul", "ringo"], 5)

      assert Enum.member?(usage, {"george", 1, three_days_ago})
      assert Enum.member?(usage, {"john", 3, yesterday})
      assert Enum.member?(usage, {"paul", 2, yesterday})
    end
  end
end
