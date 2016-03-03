defmodule MapData.Map5Jumps do
  alias MapData.MapLink

  def get_5_jump(id) do
    get_map_depth([id], 5, [id])
    |>Enum.with_index()
    |>Enum.map(fn {x, depth} -> Enum.map(x, &({&1,depth})) end)
    |>Enum.flatten()
  end

  defp get_map_depth(list, 0, acc) do
    acc
  end

  defp get_map_depth(list, depth, acc) do
    result = list
    |> get_multiple_links()
    |> Enum.flatten()
    |> Enum.uniq
    |> Enum.filter(fn x -> not_in_rest(x,acc))
    |> get_map_depth(depth-1,[acc | result])
  end

  defp not_in_rest(x,acc) do
    list = Enum.flatten(acc)
    x not in list
  end
end
