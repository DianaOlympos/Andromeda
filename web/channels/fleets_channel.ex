defmodule Andromeda.FleetsChannel do
  use Phoenix.Channel

  def join("fleet:lobby", _message, socket) do
    {:ok, socket}
  end

  def join("fleet:" <> _private_room_id, _params, socket) do
    user = Guardian.Phoenix.Socket.current_resource(socket)
    {:ok, socket}
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