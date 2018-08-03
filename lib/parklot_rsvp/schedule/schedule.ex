defmodule ParklotRsvp.Schedule do
  @moduledoc """
  The Schedule context.
  """

  import Ecto.Query, warn: false
  alias ParklotRsvp.Repo

  alias ParklotRsvp.Schedule.Reservation

  @doc """
  Returns the list of reservations.

  ## Examples

      iex> list_reservations()
      [%Reservation{}, ...]

  """
  def list_reservations do
    Repo.all(Reservation)
  end

  @doc """
  Gets a single reservation.

  Raises `Ecto.NoResultsError` if the Reservation does not exist.

  ## Examples

      iex> get_reservation!(123)
      %Reservation{}

      iex> get_reservation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_reservation!(id), do: Repo.get!(Reservation, id)

  @doc """
  Gets a single reservation by user and scheduled date.

  Raises `Ecto.NoResultsError` if the Reservation does not exist.

  ## Examples

      iex> get_reservation!('juan', ~D[2018-06-17])
      %Reservation{}

      iex> get_reservation!('juan', ~D[2010-04-17])
      ** (Ecto.NoResultsError)

  """
  def get_reservation_by_user_and_date!(user, scheduled_at) do
    Repo.get_by!(Reservation, user: user, scheduled_at: scheduled_at)
  end

  @doc """
  Returns the list of reservations on a specific scheduled date.

  ## Examples

      iex> get_reservations_by_date(~D[2010-04-17])
      [%Reservation{}, ...]

  """
  def get_reservations_by_date(scheduled_at) do
    query = from r in Reservation,
          where: r.scheduled_at == ^scheduled_at

    Repo.all(query)
  end

  @doc """
  Updates a reservation confirmed status.

  ## Examples

      iex> update_reservation(reservation)
      {:ok, %Reservation{}}

      iex> update_reservation(reservation)
      {:error, %Ecto.Changeset{}}

  """
  def confirm_reservation(%Reservation{} = reservation) do
    reservation
    |> Reservation.update_changeset(%{confirmed: true})
    |> Repo.update()
  end

  @doc """
  Returns the total confirmed reservations with the last day
  used filtered by a list of users and scheduled between a number
  of days ago and the current date.

  ## Examples

      iex> get_usage_by_users(['jose', 'pedro'], 30)
      [%Reservation{}, ...]

  """
  def get_usage_by_users(users, days_ago) do
    query = from r in Reservation,
    group_by: r.user,
    select: {r.user, count(r.id), max(r.scheduled_at)},
    where: r.confirmed == true
       and r.scheduled_at > ago(^days_ago, "day")
       and r.scheduled_at <= ^Timex.today
       and r.user in ^users

    Repo.all(query)
  end

  @doc """
  Creates a reservation.

  ## Examples

      iex> create_reservation(%{field: value})
      {:ok, %Reservation{}}

      iex> create_reservation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_reservation(attrs \\ %{}) do
    %Reservation{}
    |> Reservation.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a reservation.

  ## Examples

      iex> update_reservation(reservation, %{field: new_value})
      {:ok, %Reservation{}}

      iex> update_reservation(reservation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_reservation(%Reservation{} = reservation, attrs) do
    reservation
    |> Reservation.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Reservation.

  ## Examples

      iex> delete_reservation(reservation)
      {:ok, %Reservation{}}

      iex> delete_reservation(reservation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_reservation(%Reservation{} = reservation) do
    Repo.delete(reservation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking reservation changes.

  ## Examples

      iex> change_reservation(reservation)
      %Ecto.Changeset{source: %Reservation{}}

  """
  def change_reservation(%Reservation{} = reservation) do
    Reservation.changeset(reservation, %{})
  end
end
