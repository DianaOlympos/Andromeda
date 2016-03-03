defmodule Andromeda.FleetsChannel do
  use Phoenix.Channel

  def join("pilot:" <> _user_id , _message, socket) do
    user = Guardian.Phoenix.Socket.current_resource(socket)
    fleet = EveFleet.Fleet.get_data_id(user.fleet_id)
    {:ok, fleet.member_list, socket}
  end

  def join("fleet:" <> _fleet_id, _params, socket) do
    user = Guardian.Phoenix.Socket.current_resource(socket)
    {:ok, user.id, socket}
  end

  def handle_in("new_msg", %{"body" => body}, socket) do
    broadcast! socket, "new_msg", %{body: body}
    {:noreply, socket}
  end

  def handle_out("new_msg", payload, socket) do
    push socket, "new_msg", payload
    {:noreply, socket}
  end
end