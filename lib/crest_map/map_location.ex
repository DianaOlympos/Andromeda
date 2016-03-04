defmodule CrestMap.MapLocation do
  alias CrestMap.LocationSolarSystem
  alias HTTPoison.Response
  alias EveUser.UserDetails

  def location_handling(id) do
    get_location(id)
    |>location
  end

  def location({user, {:ok, %Response{status_code: 200, body: "{}"}}}) do
  end

  def location({user, {:ok, %Response{status_code: 200, body: body}}}) do
    IO.inspect(body,[binaries: :as_string])
    system = Poison.decode!(body, as: %{"solarSystem" => %LocationSolarSystem{}})
    if system["solarSystem"][:id] == user.location do
      Task.Supervisor.terminate_child(CrestMap.TaskSupervisor, self)
    else
      new_user = %UserDetails{ user | :location => system["solarSystem"][:id]}
      EveUser.User.update_user(new_user.id, new_user)
      fleet = EveFleet.Fleet.get_data_id(user.fleet)
      Andromeda.Endpoint.broadcast! "pilot:"<>Integer.to_string(fleet.fc), "location_member", %{member_id: user.id, member_name: user.name, location: system["solarSystem"]}
      Andromeda.Endpoint.broadcast! "pilot:"<>Integer.to_string(user.id), "location", %{member_id: user.id, member_name: user.name, location: system["solarSystem"]}
      Andromeda.Endpoint.broadcast! "pilot:"<>Integer.to_string(user.id), "map", %{map: MapData.Map5Jumps.get_5_jump(system["solarSystem"])}
    end
  end

  def location({user, _}) do
    get_location(user.id)
  end

  defp get_location(id) do
    {:ok, user} = EveUser.User.get_user(id)
    result = HTTPoison.get("https://api-sisi.testeveonline.com/characters/#{id}/location/",header(user))
    {user,result}
    end

  defp header(user) do
    user_agent = Application.get_env(:andromeda,:user_agent)
      [{"Accept", "application/json"},
        {"accept-encoding", "gzip"},
        {"user-agent", user_agent},
        {"X-Clacks-Overhead", "GNU Terry Pratchett"},
        {"Authorization", "Bearer " <>user.access_token}
      ]
  end

end
