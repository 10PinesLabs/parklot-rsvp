defmodule ParklotRsvp.Fixtures do

  alias ParklotRsvp.Schedule

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

  def confirmed_reservation_fixture(attrs \\ %{}) do
    reservation = reservation_fixture(attrs)
    {:ok, reservation} = Schedule.confirm_reservation(reservation)

    reservation
  end

  def work_related_reservation_fixture(attrs \\ %{}) do
    reservation_fixture(Map.merge(attrs, %{work_related: true}))
  end

  def valid_reservation_attrs do
    @valid_attrs
  end

  def update_reservation_attrs do
    @update_attrs
  end

  def invalid_reservation_attrs do
    @invalid_attrs
  end

  def valid_reservation_attrs_without_notes do
    @valid_attrs_without_notes
  end
end
