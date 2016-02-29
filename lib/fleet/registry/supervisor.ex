defmodule EveFleet.Registry.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      worker(EveFleet.Registry, [EveFleet.Registry]),
      supervisor(EveFleet.Fleet.Supervisor, [])
    ]

    supervise(children, strategy: :rest_for_one)
  end
end