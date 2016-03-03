defmodule MapData.Map5Jumps do
  alias MapData.MapLink

  def get_5_jump(id) do
    get_map_depth([id],5, acc)
  end

  def get_map_depth(list, depth, acc) do
    list
    |> get_multiple_links()
    |> Enum.flatten()
    |> Enum.sort()
    |> Enum.dedup()
    |> Enum.filter(fn x -> x not in acc)
  end
