defmodule ParklotRsvpWeb.Router do
  use ParklotRsvpWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ParklotRsvpWeb do
    pipe_through :api

    resources "/reservations", ReservationController, except: [:new, :edit]
    post "/reservations/run_from_slack", ReservationController, :run_from_slack
    post "/reservations/confirm_reservation", ReservationController, :confirm_reservation
  end

  if Mix.env == :dev do
    forward "/sent_emails", Bamboo.SentEmailViewerPlug
  end
end
