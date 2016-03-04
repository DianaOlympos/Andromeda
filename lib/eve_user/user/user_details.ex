defmodule EveUser.UserDetails do
  defstruct id: 0,
            name: "John Doe",
            corporation: "Error Please Ignore",
            alliance: "",
            corporation_id: 0,
            alliance_id: 0,
            fleet: "",
            refresh_token: "",
            access_token: "",
            location: 0,
            follow_fc: true

  @type t :: %EveUser.UserDetails{
    id: integer,
    name: String.t,
    corporation: String.t,
    alliance: String.t,
    corporation_id: integer,
    alliance_id: integer,
    fleet: String.t,
    refresh_token: String.t,
    access_token: String.t,
    location: integer,
    follow_fc: boolean}
end