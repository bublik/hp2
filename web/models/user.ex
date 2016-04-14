defmodule Ph2.User do
  use Ph2.Web, :model

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :phone, :string
    field :authentication_token, :string

    timestamps
  end

  @required_fields ~w(first_name last_name email)
  @optional_fields ~w(authentication_token phone)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_format(:email, ~r/@/)
  end

  def ignoring?(user, user_id) do

  end

end
