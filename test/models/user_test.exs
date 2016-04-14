defmodule Ph2.UserTest do
  use Ph2.ModelCase

  alias Ph2.User

  @valid_attrs %{authentication_token: "some content", email: "some content", first_name: "some content", last_name: "some content", phone: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
