defmodule MapData.SystemMap do
  defstruct id: 0,
            name: "Nowhere",
            depth: 0,
            connection: []

  @type t :: %MapData.SystemMap{
    id: integer,
    name: String.t,
    depth: integer,
    connection: list}
end