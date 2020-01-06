defmodule VotrWeb.Router do
  use VotrWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", VotrWeb do
    pipe_through :browser

    live "/", MainLive
    resources "/rooms", RoomController
    get "/rooms/:id/user/new", RoomController, :new_user
    post "/rooms/:id/user", RoomController, :create_user
    resources "/users", UserController
    # live "/rooms", RoomLive.Index
    # live "/rooms/new", RoomLive.New
    # live "/rooms/:id", RoomLive.Show
  end

  # Other scopes may use custom stacks.
  # scope "/api", VotrWeb do
  #   pipe_through :api
  # end
end
