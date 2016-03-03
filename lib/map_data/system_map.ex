defmodule MapData.SystemMap do
  defstruct id: 0,
            name: "Nowhere",
            depth: 0

  @type t :: %EveFleet.FleetDetails{
    id: integer,
    name: String.t,
    fc: integer}
end