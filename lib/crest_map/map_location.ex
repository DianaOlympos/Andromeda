defmodule CrestMap.MapLocation do
  alias CrestMap.LocationSolarSystem
  alias HTTPoison.Response
  alias EveUser.UserDetails

def location_handling(id) do
  get_location(id)
  |>location
end

def location({user, {:ok, %Response{status_code: 200, body: "{}"}}}) do
  pid = EveUser.Registry.look_pid(EveUser.Registry,user.id)
  Agent.stop(pid)
end

def location({user, {:ok, %Response{status_code: 200, body: body}}}) do
  system = Poison.decode!(body, as: %{"solarSystem" => %LocationSolarSystem{}})
  if system["solarSystem"][:id] == user.location do
    Task.Supervisor.terminate_child(CrestMap.MapLocation.Supervisor,self)
  else
    new_user = %UserDetails{ user | :location => system["solarSystem"][:id]}
    EveUser.User.update_user(new_user.id, new_user)
    fleet = EveFleet.Fleet.get_data_id(user.fleet)
    Andromeda.Endpoint.broadcast! "pilot:"<>fleet.fc, "location_member", %{member_id: user.id, member_name: user.name, location: system["solarSystem"]}
    Andromeda.Endpoint.broadcast! "pilot:"<>user.id, "location", %{member_id: user.id, member_name: user.name, location: system["solarSystem"]}
    Andromeda.Endpoint.broadcast! "pilot:"<>user.id, "map", %{map: MapData.Map5Jumps.get_5_jump(system["solarSystem"])}
  end
end

def location({user, _}) do
  get_location(user.id)
end

defp get_location(id) do
  user = EveUser.User.get_user(id)
  result = "https://crest-tq.eveonline.com/characters/#{id}/location/"
  |>add_header(user)
  |>HTTPoison.get
  {user,result}
  end

  defp add_header(url, user) do
    user_agent = Application.get_env(:andromeda,:user_agent)
    [url,
      [{"Accept", "application/json"},
        {"accept-encoding", "gzip"},
        {"user-agent", user_agent},
        {"X-Clacks-Overhead", "GNU Terry Pratchett"},
        {"Authorization", "Bearer " <>user.access_token}
      ]
    ]
  end

end
