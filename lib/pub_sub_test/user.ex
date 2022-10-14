defmodule PubSubTest.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :email, :string
    field :home_id, :integer

    timestamps()
  end

  def changeset(attrs \\ %{}) do
    changeset(%__MODULE__{}, attrs)
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :home_id])
    |> validate_required([:name, :email, :home_id])
  end

  def apply(%{ valid?: false } = changeset), do: {:error, changeset}
  def apply(changeset), do: {:ok, apply_changes(changeset)}
end
