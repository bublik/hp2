// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "web/static/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/my_app/endpoint.ex":
import {Socket} from "phoenix"

var token = $('meta[name=channel_token]').attr('content');
let socket = new Socket("/socket", {params: {token: token}})
socket.connect()

// When you connect, you'll often need to authenticate the client.
// For example, imagine you have an authentication plug, `MyAuth`,
// which authenticates the session and assigns a `:current_user`.
// If the current user exists you can assign the user's token in
// the connection for use in the layout.
//
// In your "web/router.ex":
//
//     pipeline :browser do
//       ...
//       plug MyAuth
//       plug :put_user_token
//     end
//
//     defp put_user_token(conn, _) do
//       if current_user = conn.assigns[:current_user] do
//         token = Phoenix.Token.sign(conn, "user socket", current_user.id)
//         assign(conn, :user_token, token)
//       else
//         conn
//       end
//     end
//
// Now you need to pass this token to JavaScript. You can do so
// inside a script tag in "web/templates/layout/app.html.eex":
//
//     <script>window.userToken = "<%= assigns[:user_token] %>";</script>
//
// You will need to verify the user token in the "connect/2" function
// in "web/channels/user_socket.ex":
//
//     def connect(%{"token" => token}, socket) do
//       # max_age: 1209600 is equivalent to two weeks in seconds
//       case Phoenix.Token.verify(socket, "user socket", token, max_age: 1209600) do
//         {:ok, user_id} ->
//           {:ok, assign(socket, :user, user_id)}
//         {:error, reason} ->
//           :error
//       end
//     end
//
// Finally, pass the token on connect as below. Or remove it
// from connect if you don't care about authentication.


var lobby_changel = socket.channel('game:lobby');
let lobby = $("#lobby")
let messagesContainer = $("#messages")
let chatInput         = $("#chat-input")


lobby_changel.on('lobby_update', function (response) {
  lobby.html('')
  $.each(response.users, function(num, user_name) {
    lobby.append(`<a onclick="invitePlayer('${user_name}')">${user_name}</a>`)
  });
  //lobby.text(JSON.stringify(response.users))
  console.log(response.users);
  console.log(JSON.stringify(response.users));
});

lobby_changel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
.receive("error", resp => { console.log("Unable to join", resp) })

lobby_changel.on('game_invite', function (response) {
  messagesContainer.append(`<br/>[${Date()}] You were invited to join a game by ${response.username}`)
});

window.invitePlayer = function (username) { lobby_changel.push('game_invite', {username: username}) };

chatInput.on("keypress", event => {
  if(event.keyCode === 13){
   lobby_changel.push("new_msg", {body: chatInput.val()})
   chatInput.val("")
  }
})

lobby_changel.on("new_msg", response => {
  messagesContainer.append(`<br/>[${response.time}] ${response.username} > ${response.body}`)
})

export default socket