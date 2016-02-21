defmodule Andromeda.FleetController do
  use Andromeda.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: Andromeda.AuthController

  def index(conn, _params) do
    render conn, "application.html"
  end

  def fleet(conn, %{"fleet_id"=>fleet_id}) do
    user = Guardian.Plug.current_resource(conn)
    render conn, "application.html"
  end

end
