defmodule Votr.Voting.Room do
  use Ecto.Schema
  import Ecto.Changeset

  # Do NOT alter this unless you're prepared to do a migration.
  @statuses ~w[voting_options voting]

  schema "rooms" do
    field :name, :string
    field :status, :string

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
  # For creating a new room, which requires having at least one user.
  def creation_changeset(%__MODULE__{} = room, attrs) do
    changeset(room, attrs)
    |> cast_assoc(:users, required: true)
    |> validate_length(:users, min: 1)
  end

  @doc """
  Possible statuses for a room's state. Be mindful of altering these values in
  any way, as they are stored in the database and must be migrated when changed.
  """
  def statuses do
    @statuses
  end

  @doc """
  Gets a status representing a room's state. This ensures that other parts of
  the code are only selecting valid statuses, failing to match otherwise.
  """
  def get_status(status) when status in @statuses, do: status
end
