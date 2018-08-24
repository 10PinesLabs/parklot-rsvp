# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ParklotRsvp.Repo.insert!(%ParklotRsvp.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias ParklotRsvp.Schedule

{:ok, reservation} = %{scheduled_at: "2018-07-30", user: "egutter"} |> Schedule.create_reservation
Schedule.confirm_reservation(reservation)

{:ok, reservation} = %{scheduled_at: "2018-07-31", user: "lucas"} |> Schedule.create_reservation
Schedule.confirm_reservation(reservation)

{:ok, reservation} = %{scheduled_at: "2018-08-01", user: "lucas"} |> Schedule.create_reservation
Schedule.confirm_reservation(reservation)

{:ok, reservation} = %{scheduled_at: "2018-08-02", user: "tuk"} |> Schedule.create_reservation
Schedule.confirm_reservation(reservation)

{:ok, reservation} = %{scheduled_at: "2018-08-03", user: "fzuppa"} |> Schedule.create_reservation
Schedule.confirm_reservation(reservation)

{:ok, reservation} = %{scheduled_at: "2018-08-06", user: "fzuppa"} |> Schedule.create_reservation
Schedule.confirm_reservation(reservation)

{:ok, reservation} = %{scheduled_at: "2018-08-09", user: "tuk"} |> Schedule.create_reservation
Schedule.confirm_reservation(reservation)

{:ok, reservation} = %{scheduled_at: "2018-08-10", user: "fzuppa"} |> Schedule.create_reservation
Schedule.confirm_reservation(reservation)

{:ok, reservation} = %{scheduled_at: "2018-08-13", user: "lucas"} |> Schedule.create_reservation
Schedule.confirm_reservation(reservation)

{:ok, reservation} = %{scheduled_at: "2018-08-14", user: "hernan.wilkinson"} |> Schedule.create_reservation
Schedule.confirm_reservation(reservation)

{:ok, reservation} = %{scheduled_at: "2018-08-17", user: "tuk"} |> Schedule.create_reservation
Schedule.confirm_reservation(reservation)

{:ok, reservation} = %{scheduled_at: "2018-08-21", user: "fzuppa"} |> Schedule.create_reservation
Schedule.confirm_reservation(reservation)

{:ok, reservation} = %{scheduled_at: "2018-08-22", user: "lucas"} |> Schedule.create_reservation
Schedule.confirm_reservation(reservation)

{:ok, reservation} = %{scheduled_at: "2018-08-23", user: "hernan.wilkinson"} |> Schedule.create_reservation
Schedule.confirm_reservation(reservation)

{:ok, reservation} = %{scheduled_at: "2018-08-24", user: "jorgesilva"} |> Schedule.create_reservation
Schedule.confirm_reservation(reservation)

{:ok, reservation} = %{scheduled_at: "2018-08-27", user: "hernan.wilkinson"} |> Schedule.create_reservation
Schedule.confirm_reservation(reservation)

{:ok, reservation} = %{scheduled_at: "2018-08-28", user: "fzuppa"} |> Schedule.create_reservation
Schedule.confirm_reservation(reservation)
