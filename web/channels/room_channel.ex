defmodule ChatPhoenix.RoomChannel do
  use Phoenix.Channel

  # join
  def join("room:lobby", _message, socket) do
    {:ok, socket}
  end
  def join("room:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  # broadcast!/3 will notify all joined clients on this socket's topic and invoke their handle_out/3 callbacks.
  # handle_out/3 isn't a required callback, but it allows us to customize and filter broadcasts before they reach each client
  def handle_in("new_msg", %{"body" => body}, socket) do
    broadcast! socket, "new_msg", %{body: body}
    {:noreply, socket}
  end
  def handle_out("new_msg", payload, socket) do
    push socket, "new_msg", payload
    {:noreply, socket}
  end
end