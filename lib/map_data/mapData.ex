defmodule MapData do
alias CSV

  def produce_map() do
   File.stream!("mapSolarSystemJumps.csv")
   |>CSV.decode(headers: true)
   |>Stream.map(fn %{"fromSolarSystemID" => from, "toSolarSystemID" => to} -> {String.to_integer(to), [String.to_integer(from)]} end)
   |>Enum.reduce(%{},fn ({to,from},map)-> Map.update(map,to,from,&(&1++from)) end)
  end

end
