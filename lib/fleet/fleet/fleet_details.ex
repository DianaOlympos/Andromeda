defmodule EveFleet.FleetDetails do
  defstruct id: "",
            name: "Test Fleet Please Ignore",
            fc: 0,
            members_list: []

  @type t :: %EveFleet.FleetDetails{
    id: String.t,
    name: String.t,
    fc: integer,
    members_list: [integer]}
end