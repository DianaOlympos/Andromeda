defmodule Andromeda.FleetsChannel do
  use Phoenix.Channel

  def join("pilot:" <> _user_id , _message, socket) do
    user = Guardian.Phoenix.Socket.current_resource(socket)
    fleet = EveFleet.Fleet.get_data_id(user.fleet)

    members=Enum.map(fleet.members_list,fn x -> %{:id => x, :name => EveUser.User.get_user_name(x)} end)
    {:ok, members, socket}
  end

  def join("fleet:" <> _fleet_id, _params, socket) do
    user = Guardian.Phoenix.Socket.current_resource(socket)
    {:ok, user.id, socket}
  end

  def handle_in("location_member", payload, socket) do
    push socket, "location_member", payload
    {:noreply, socket}
  end



end