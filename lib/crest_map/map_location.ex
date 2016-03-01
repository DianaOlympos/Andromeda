defmodule CrestMap.MapLocation do
  alias CrestMap.LocationSolarSystem
  alias HTTPoison.Response


def location_handling(id) do
  get_location(id)
  |>location
end

def location({user, {:ok, %Response{status_code: 200, body: "{}"}}}) do
  #sign out user
end

def location({user, {:ok, %Response{status_code: 200, body: body}}}) do
  system = Poison.decode!(body, as: %{"solarSystem" => %LocationSolarSystem{}})
  if system["people"][:id] == user.location do
    Task.Supervisor.terminate_child(CrestMap.MapLocation.Supervisor,self)
  else
    #calculer la map et la broadcast a l'utilisateur
    Andromeda.Endpoint.broadcast! "fleet_fc:"<>user.fleet_id, "location", %{member_id: user.id, member_name: user.name, location: system["people"]}
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
