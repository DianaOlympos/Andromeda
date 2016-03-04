defmodule CrestMap.LocationWrite do
  alias CrestMap.SolarSystem

  defstruct solarSystem: %SolarSystem{},
            first: false,
            clearOtherWaypoint: true

  @type t :: %CrestMap.LocationWrite{
            solarSystem: SolarSystem.t,
            first: boolean,
            clearOtherWaypoint: boolean
  }
end