defmodule EveFleet.Fleet do
  use GenServer
  alias EveFleet.FleetDetails
  alias EveUser.UserDetails

 # Client

  def start_link() do
    GenServer.start_link(__MODULE__, %FleetDetails{})
  end

  def get_data(pid) do
    GenServer.call(pid, :get)
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
    %FleetDetails{ fleet | :members_list => [member | fleet.members_list]}
    {:ok, user} = EveUser.User.get_user(member)
    %UserDetails{user | :fleet => fleet.id}
    EveUser.User.update_user(member, user)
    Process.send_after(self, {:update_location, member}, 15000)
    {:reply, {:ok}, fleet}
  end

  def handle_call({:pop, member}, _from, fleet) do
    list = fleet.members_list
    if member in list do
      list=List.delete(member)
    end
    %FleetDetails{ fleet | :members_list => list}
    {:reply, {:ok}, fleet}
  end

  def handle_call({:update, new_fleet}, _from, _fleet) do
    {:reply, {:ok}, new_fleet}
  end

  def handle_info({:update_location, member}, _from, fleet) do
    if member in fleet.member_list do
      Task.Supervisor.start_child(CrestMap.MapLocation.Supervisor,fn -> CrestMap.MapLocation.location_handling(member) end)
      Process.send_after(self, {:update_location, member}, 15000)
    end
    {:no_reply, fleet}
  end
end