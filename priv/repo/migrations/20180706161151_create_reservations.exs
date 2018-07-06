defmodule ParklotRsvp.Repo.Migrations.CreateReservations do
  use Ecto.Migration

  def change do
    create table(:reservations) do
      add :user, :string
      add :scheduled_at, :date
      add :work_related, :boolean, default: false, null: false
      add :notes, :string

      timestamps()
    end

  end
end
