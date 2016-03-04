defmodule Andromeda.FleetController do
  use Andromeda.Web, :controller
  alias EveFleet.FleetDetails

  plug Guardian.Plug.EnsureAuthenticated, handler: Andromeda.AuthController
  plug :scrub_params, "name" when action in [:create]

  def index(conn, _params) do
    render conn, "fleet_creation.html"
  end

  def fleet(conn, %{"fleet_id" => fleet_id}) do
    user = Guardian.Plug.current_resource(conn)
    if user.fleet == fleet_id do
      render conn, "application.html", fleet_id: fleet_id
    else
      {:ok, pid} = EveFleet.Registry.look_pid(EveFleet.Registry,fleet_id)
      EveFleet.Fleet.add_member(pid, user.id)

      render conn, "application.html", fleet_id: fleet_id
    end
  end

  def create(conn, %{"name" => name}) do
    fc = Guardian.Plug.current_resource(conn)

    fleet_id = UUID.uuid4()
    fleet = %FleetDetails{
      id: fleet_id,
      name: name,
      fc: fc.id,
      members_list: []
    }


    pid = EveFleet.Registry.create(EveFleet.Registry, fleet)
    EveFleet.Fleet.add_member(pid, fc.id)
    |>IO.inspect
    redirect conn, to: "/fleet/"<>fleet_id
  end
end
