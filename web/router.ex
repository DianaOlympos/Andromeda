defmodule Andromeda.Router do
  use Andromeda.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :browser_session do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/fleet", Andromeda do
    pipe_through [:browser, :browser_session]

    get "/", FleetController, :index
    get "/:fleet_id", FleetController, :fleet
  end

  scope "/auth", Andromeda do
    pipe_through [:browser, :browser_session]

    get "/", AuthController, :index
    get "/:fleet_id", AuthController, :index
    get "/callback", AuthController, :callback
    get "/signout", AuthController, :signout
  end

  scope "/", Andromeda do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", Andromeda do
  #   pipe_through :api
  # end
end
