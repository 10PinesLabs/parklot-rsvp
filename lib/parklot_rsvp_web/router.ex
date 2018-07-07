defmodule ParklotRsvpWeb.Router do
  use ParklotRsvpWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ParklotRsvpWeb do
    pipe_through :api

    resources "/reservations", ReservationController, except: [:new, :edit]
    post "/reservations/create_from_slack", ReservationController, :create_from_slack      
  end
end
