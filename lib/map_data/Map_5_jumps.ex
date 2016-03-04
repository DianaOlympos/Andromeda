defmodule MapData.Map5Jumps do
  alias MapData.SystemMap

  def get_5_jump(id) do
    get_map_depth([id], 5, [[id]])
    |>Enum.reverse()
    |>Enum.with_index()
    |>Enum.map(fn {x, depth} -> Enum.map(x, &({&1,depth})) end)
    |>List.flatten()
    |>Enum.map(fn {x, depth} -> %SystemMap{id: x, depth: depth, name: MapData.MapName.get_name(x), connection: MapData.MapLink.get_links(x)} end)
  end

  defp get_map_depth(_list, 0, acc) do
    acc
  end

  defp get_map_depth(list, depth, acc) do
    result =list
    |> MapData.MapLink.get_multiple_links()
    |> List.flatten()
    |> Enum.uniq
    |> Enum.filter(fn x -> not_in_rest(x,acc) end)

    get_map_depth(result, depth-1,[result | acc])
  end

  defp not_in_rest(x,acc) do
    test = acc
    |>List.flatten(acc)
    |>Enum.member?(x)
    not test
  end
end
