defmodule Ph2.UserSocket do
  use Phoenix.Socket
  alias Ph2.{Repo, User}

  ## Channels
  channel "rooms:*", Ph2.RoomChannel
  channel "game:lobby", Ph2.LobbyChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket
  # transport :longpoll, Phoenix.Transports.LongPoll

  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.
#  def connect(_params, socket) do
#    {:ok, socket}
#  end

  def connect(%{"token" => token}, socket) do
    # 1 day = 86400 seconds
    case Phoenix.Token.verify(socket, "user", token, max_age: 86400) do
      {:ok, user_id} ->
        socket = assign(socket, :current_user, Repo.get!(User, user_id))
        {:ok, socket}
      {:error, _} ->
        :error
    end
  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "users_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     Ph2.Endpoint.broadcast("users_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  def id(_socket), do: nil
end