defmodule Votr.Voting.Room do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rooms" do
    field :name, :string

    has_many :users, Votr.Voting.User

    timestamps()
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:name])
    |> cast_assoc(:users, required: true)
    |> validate_required([:name])
    |> validate_length(:users, min: 1)
  end
end
