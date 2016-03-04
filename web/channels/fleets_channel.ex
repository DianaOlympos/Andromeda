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

  def handle_in("follow_fc", payload, socket) do
    user = Guardian.Phoenix.Socket.current_resource(socket)
    update_user = %UserDetails{user | :follow_fc => String.to_atom(payload)}
    EveUser.User.update_user(member, update_user)
    {:noreply, socket}
  end



end