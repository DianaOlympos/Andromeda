defmodule EveFleet.Fleet.Supervisor do
  use Supervisor
  # A simple module attribute that stores the supervisor name
  @name EveFleet.Fleet.Supervisor

  def start_link() do
    Supervisor.start_link(__MODULE__, :ok, name: @name)
  end

  def start_fleets() do
    Supervisor.start_child(@name,[])
  end

  def init(:ok) do
    children = [
      worker(EveFleet.Fleet, [], restart: :transient)
    ]

    supervise(children, strategy: :simple_one_for_one)
  end
end