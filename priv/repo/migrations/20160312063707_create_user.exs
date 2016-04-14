defmodule Ph2.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string
      add :last_name, :string
      add :email, :string
      add :phone, :string
      add :authentication_token, :string

      timestamps
    end

  end
end
