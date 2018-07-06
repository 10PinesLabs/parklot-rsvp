defmodule ParklotRsvpWeb.Router do
  use ParklotRsvpWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ParklotRsvpWeb do
    pipe_through :api

    resources "/reservations", ReservationController, except: [:new, :edit]
  end
end
