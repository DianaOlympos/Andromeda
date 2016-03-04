defmodule CrestMap.SolarSystem do

  defstruct href: "",
            id: 0

  @type t :: %CrestMap.SolarSystem{
            href: String.t,
            id: integer
  }
end