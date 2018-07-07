defmodule ParklotRsvp.Schedule.Reservation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reservations" do
    field :notes, :string
    field :scheduled_at, Timex.Ecto.Date
    field :user, :string
    field :work_related, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(reservation, attrs) do
    reservation
    |> cast(attrs, [:user, :scheduled_at, :work_related, :notes])
    |> validate_required([:user, :scheduled_at])
    |> set_work_related
  end

  defp set_work_related(changeset) do
    case fetch_field(changeset, :notes) do
      {:changes, _notes} -> force_change(changeset, :work_related, true)
      _ -> changeset
    end
  end
end
