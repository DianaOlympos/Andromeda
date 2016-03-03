defmodule CrestMap.Supervisor do
  use Supervisor
  import Supervisor.Spec

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      supervisor(Task.Supervisor, [[name: CrestMap.TaskSupervisor]])
    ]

    supervise(children, strategy: :one_for_one)
  end
end