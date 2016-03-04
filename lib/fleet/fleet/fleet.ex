defmodule EveFleet.Fleet do
  use GenServer
  alias EveFleet.FleetDetails
  alias EveUser.UserDetails

 # Client

  def start_link() do
    GenServer.start_link(__MODULE__, %FleetDetails{})
  end

  def get_data(pid) when is_pid(pid) do
    GenServer.call(pid, :get)
  end

  def get_data_id(id) do
    with {:ok, pid} <- EveFleet.Registry.look_pid(EveFleet.Registry, id),
      do: GenServer.call(pid, :get)
  end

  def add_member(pid, member) do
    GenServer.call(pid, {:add, member})
  end

  def pop_member(pid, member) do
    GenServer.call(pid, {:pop, member})
  end

  def update(pid, fleet) do
    GenServer.call(pid, {:update, fleet})
  end

  def stop(server) do
    GenServer.stop(server)
  end

  # Server (callbacks)

  def handle_call(:get, _from, fleet) do
    {:reply, fleet, fleet}
  end

  def handle_call({:add, member}, _from, fleet) do
    update_fleet = %FleetDetails{ fleet | :members_list => [member | fleet.members_list]}
    {:ok, user} = EveUser.User.get_user(member)
    update_user = %UserDetails{user | :fleet => update_fleet.id}
    EveUser.User.update_user(member, update_user)
    Process.send_after(self(), {:update_location, member}, 1000)
    Process.send_after(self(), :members_list, 500)
    {:reply, {:ok, update_fleet}, update_fleet}
  end

  def handle_call({:pop, member}, _from, fleet) do
    list = fleet.members_list
    if member in list do
      list=List.delete(member)
    end
    new_fleet = %FleetDetails{ fleet | :members_list => list}
    {:reply, {:ok}, new_fleet}
  end

  def handle_call({:update, new_fleet}, _from, _fleet) do
    {:reply, {:ok}, new_fleet}
  end

  def handle_info({:update_location, member}, fleet) do
    if Enum.member?(fleet.members_list,member) do
      Task.Supervisor.start_child(CrestMap.TaskSupervisor,fn -> CrestMap.MapLocation.location_handling(member) end)
      Process.send_after(self(), {:update_location, member}, 15000)
    end
    {:noreply, fleet}
  end

    def handle_info(:members_list, fleet) do
      Andromeda.Endpoint.broadcast! "fleet:"<>fleet.id, "pilot_list", %{pilots: Enum.map(fleet.members_list,fn x -> %{:id => x, :name => EveUser.User.get_user_name(x)} end)}
    {:noreply, fleet}
  end
end