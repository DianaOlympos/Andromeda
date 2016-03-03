defmodule MapData.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      worker(MapData.MapLink, [MapData.MapLink], restart: :transient),
      worker(MapData.MapName, [MapData.MapName], restart: :transient)
      ]

    supervise(children, strategy: :one_for_one)
  end
end
