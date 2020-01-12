defmodule Votr.Voting.Room do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rooms" do
    field :name, :string

    has_many :users, Votr.Voting.User
    has_many :vote_options, Votr.Voting.VoteOption

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = room, attrs) do
    room
    |> cast(attrs, [:name])
    |> cast_assoc(:vote_options)
    |> validate_required([:name])
    |> validate_length(:name, min: 3)
    |> unsafe_validate_unique([:name], Votr.Repo)
    |> unique_constraint(:name)
  end

  @doc false
  # For creating a new room, which requires having one user.
  def creation_changeset(%__MODULE__{} = room, attrs) do
    changeset(room, attrs)
    |> cast_assoc(:users, required: true)
    |> validate_length(:users, is: 1)
  end
end
