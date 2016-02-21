defmodule EveUser.User.Supervisor do
  use Supervisor
  # A simple module attribute that stores the supervisor name
  @name EveUser.User.Supervisor

  def start_link() do
    Supervisor.start_link(__MODULE__, :ok, name: @name)
  end

  def start_users() do
    Supervisor.start_child(@name,[])
  end

  def init(:ok) do
    children = [
      worker(EveUser.User, [], restart: :temporary)
    ]

    supervise(children, strategy: :simple_one_for_one)
  end
end