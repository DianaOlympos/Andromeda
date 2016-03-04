defmodule CrestMap.LocationSolarSystem do

  defstruct [:id_str,
            :href,
            :id,
            :name]

  @type t :: %CrestMap.LocationSolarSystem{[
            id_str: String.t,
            href: String.t,
            id: integer,
            name: String.t]
  }
end