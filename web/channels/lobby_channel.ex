defmodule Ph2.LobbyChannel do
  use Ph2.Web, :channel
  alias Ph2.ChannelMonitor
  require Logger

  def join("game:lobby", _payload, socket) do
    current_user = socket.assigns.current_user
    users = ChannelMonitor.user_joined("game:lobby", current_user)["game:lobby"]
    send self, {:after_join, users}
    {:ok, socket}
  end

  def terminate(_reason, socket) do
    user_id = socket.assigns.current_user.id
    users = ChannelMonitor.user_left("game:lobby", user_id)["game:lobby"]
    lobby_update(socket, users)
    :ok
  end

  def handle_info({:after_join, users}, socket) do
    lobby_update(socket, users)
    {:noreply, socket}
  end

  defp lobby_update(socket, users) do
    broadcast! socket, "lobby_update", %{ users: get_usernames(users) }
  end

  defp get_usernames(nil), do: []
  defp get_usernames(users) do
    Enum.map users, &(&1.first_name)
  end

  def handle_in("game_invite", %{"username" => username}, socket) do
    data = %{"username" => username, "sender" => socket.assigns.current_user.first_name }
    broadcast! socket, "game_invite", data
    {:noreply, socket}
  end

  intercept ["game_invite", "new_msg"]
  def handle_out("game_invite", %{"username" => username, "sender" => sender}, socket)do
    if socket.assigns.current_user.first_name == username && sender != username do
      push socket, "game_invite", %{ username: sender}
    end
    {:noreply, socket}
  end

 def handle_in("new_msg", %{"body" => body}, socket) do
    Logger.debug "> handle_in new_msg "
    broadcast! socket, "new_msg", %{body: body,
                                    time: Ecto.Time.to_string(Ecto.Time.utc),
                                    username: socket.assigns.current_user.first_name}
    {:noreply, socket}
  end

  def handle_out("new_msg", response, socket) do
    Logger.debug "> handle_out new_msg  #{inspect response}"
    push socket, "new_msg", response
    {:noreply, socket}
  end

end
