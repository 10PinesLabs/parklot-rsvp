defmodule ParklotRsvp.Schedule.Reservation do
  use Ecto.Schema
  import Ecto.Changeset


  schema "reservations" do
    field :notes, :string
    field :scheduled_at, :date
    field :user, :string
    field :work_related, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(reservation, attrs) do
    reservation
    |> cast(attrs, [:user, :scheduled_at, :work_related, :notes])
    |> validate_required([:user, :scheduled_at, :work_related, :notes])
  end
end
