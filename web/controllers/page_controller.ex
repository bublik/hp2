defmodule Ph2.PageController do
  use Ph2.Web, :controller
  alias Ph2.User

  def index(conn, %{"user_id" => user_id}) do
    user = Repo.get!(User, user_id || Enum.random([1, 2, 3]))
    token = Phoenix.Token.sign(conn, "user", user.id)
    render conn, "index.html", %{current_user: user, token: token}
  end
end
