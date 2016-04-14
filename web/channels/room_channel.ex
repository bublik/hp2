defmodule Ph2.RoomChannel do
  use Phoenix.Channel

intercept ["user_joined", "new_msg"]

  def join("rooms:lobby", %{"user_id" => user_id}, socket) do
    {:ok, socket}
  end

  def join("rooms:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("new_msg", %{"body" => body}, socket) do
    broadcast! socket, "new_msg", %{body: body}
    {:noreply, socket}
  end

  def handle_out("new_msg", payload, socket) do
    push socket, "new_msg", payload
    {:noreply, socket}
  end


# client asks for their current rank, push sent directly as a new event.
#      def handle_in("current_rank", socket) do
#        push socket, "current_rank", %{val: Game.get_rank(socket.assigns[:user])}
#        {:noreply, socket}
#      end
#


  # do not send broadcasted `"user_joined"` events if this socket's user
  # is ignoring the user who joined.
  def handle_out("user_joined", msg, socket) do
    unless User.ignoring?(socket.assigns[:user], msg.user_id) do
      push socket, "user_joined", msg
    end
    {:noreply, socket}
  end

end
