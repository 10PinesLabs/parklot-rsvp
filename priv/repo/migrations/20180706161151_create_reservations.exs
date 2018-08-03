defmodule ParklotRsvp.Repo.Migrations.CreateReservations do
  use Ecto.Migration

  def change do
    create table(:reservations) do
      add :user, :string
      add :scheduled_at, :date
      add :work_related, :boolean, default: false, null: false
      add :confirmed, :boolean, default: false, null: false
      add :notes, :string

      timestamps()
    end

    create unique_index(:reservations, [:user, :scheduled_at])

  end
end
