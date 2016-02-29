defmodule Andromeda.FleetController do
  use Andromeda.Web, :controller
  alias EveFleet.FleetDetails

  plug Guardian.Plug.EnsureAuthenticated, handler: Andromeda.AuthController

  def index(conn, _params) do
    render conn, "fleet_creation.html"
  end

  def fleet(conn, %{"fleet_id" => fleet_id}) do
    id = Guardian.Plug.current_resource(conn)
    user = EveUser.User.get_user(id)
    if user.fleet_id == fleet_id do
      render conn, "application.html", fleet_id: fleet_id
    else
      EveFleetFleet.look_pid(fleet_id)
      |>EveFleet.Fleet.add_member(id)
      render conn, "application.html", fleet_id: fleet_id
    end
  end

  def create(conn, %{"name" => name}) do
    fc = Guardian.Plug.current_resource(conn)

    fleet_id = UUID.uuid4()
    fleet = %FleetDetails{
      id: fleet_id,
      name: name,
      fc: fc,
      members_list: []
    }

    pid = EveFleet.Registry.create(EveFleet.Registry, fleet)
    EveFleet.Fleet.add_member(pid, fc)
    redirect conn, to: "/fleet/"<>fleet_id
  end
end
