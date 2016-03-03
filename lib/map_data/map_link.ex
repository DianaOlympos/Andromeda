defmodule MapData.MapLink do
  alias CSV

  def start_link(name) do
    Agent.start_link(__MODULE__, :produce_map,[], name: name)
end

  def get_links(id) do
    Agent.get(MapData.MapLink, fn {id=> result} ->result end)
  end

  def get_multiple_links(list_id) do
    Enum.map(list_id, fn id -> get_links(id) end)
  end

  defp produce_map() do
   File.stream!("mapSolarSystemJumps.csv")
   |>CSV.decode(headers: true)
   |>Stream.map(fn %{"fromSolarSystemID" => from, "toSolarSystemID" => to} -> {String.to_integer(to), [String.to_integer(from)]} end)
   |>Enum.reduce(%{},fn ({to,from},map)-> Map.update(map,to,from,&(&1++from)) end)
  end

end
