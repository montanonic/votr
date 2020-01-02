defmodule Votr.Voting.Room do
  @moduledoc """
  Rooms are sharable locations (via url or name lookup) that people can join to
  chat and vote on issues. All users in a room are visible to one another, and
  can communicate amongst themselves.

  A Room must always have at least one user in it to exist. Absent any active
  users, it goes away.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Votr.Voting.Room

  @primary_key {:id, :binary_id, autogenerate: false}

  embedded_schema do
    field :name, :string

    embeds_many :users, Votr.Voting.User
  end

  @doc false
  def changeset(%Room{} = room, attrs) do
    room
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> cast_embed(:users, required: true)
    |> validate_length(:users, min: 1)
    |> put_change(:id, Ecto.UUID.generate())
  end

  @doc """
  Creates a new Room struct.
  """
  def new(attrs) do
    %Room{}
    |> changeset(attrs)
    |> apply_action(:insert)
  end
end
