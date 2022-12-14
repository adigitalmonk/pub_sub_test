defmodule PubSubTest.Repo.Migrations.CreateUsersTable do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string
      add :home_id, :integer

      timestamps()
    end
  end
end
