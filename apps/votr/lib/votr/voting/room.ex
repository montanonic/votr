defmodule Votr.Voting.Room do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rooms" do
    field :name, :string

    has_many :users, Votr.Voting.User

    timestamps()
  end

  def changeset(room, params) do
    room
    |> cast(params, [:name])
    |> validate_required([:name])
    |> validate_length(:name, min: 3)
    |> unsafe_validate_unique([:name], Votr.Repo)
    |> unique_constraint(:name)
  end

  @doc """
  For creating a new room, which requires having one user.
  """
  def creation_changeset(room, params) do
    changeset(room, params)
    |> cast_assoc(:users, required: true)
    |> validate_length(:users, is: 1)
  end
end
