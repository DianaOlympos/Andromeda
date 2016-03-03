defmodule MapData.MapName do
  alias CSV

  def start_link(name) do
    Agent.start_link(__MODULE__, :produce_map,[], name: name)
end

  def get_names(id) do
    Agent.get(MapData.MapName, fn {id=> result} ->result end)
  end

  def get_multiple_name(list_id) do
    Enum.map(list_id, fn id -> get_names(id) end)
  end

  defp produce_map() do
   File.stream!("mapSolarSystemJumps.csv")
   |>CSV.decode(headers: true)
   |>Stream.map(fn %{"solarSystemID" => id, "solarSystemName" => name} -> {String.to_integer(id), name} end)
   |>Enum.reduce(%{},fn {id, name}, map -> Map.put(map,id,name) end)
  end

end
