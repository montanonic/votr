defmodule Votr.Voting do
  @moduledoc """
  The Voting context.
  """

  import Ecto.Query, warn: false
  alias Votr.Repo
  alias Votr.Voting.{VoteOption, Room}

  @doc """
  Returns the list of rooms.

  ## Examples

      iex> list_rooms()
      [%Room{}, ...]

  """
  def list_rooms do
    Repo.all(Room)
  end

  @doc """
  Gets a single room by id. Raises `Ecto.NoResultsError` if no record was found.
  """
  @spec get_room!(id :: integer, opts :: [preload: list] | nil) :: Room.t()
  def get_room!(id, opts \\ []) do
    Repo.get!(Room, id) |> Repo.preload(opts[:preload] || [])
  end

  @doc """
  Gets a single room by its name. Raises `Ecto.NoResultsError` if no record was
  found.

  Rooms have unique names; if you have the room name, you have access to it.
  """
  @spec get_room!(name :: String.t(), opts :: [preload: list] | nil) :: Room.t()
  def get_room_by_name!(name, opts \\ []) do
    Repo.get_by!(Room, name: name)
    |> Repo.preload(opts[:preload] || [])
  end

  @doc """
  Creates a room.

  Note that a room must always have at least 1 user to be valid.
  """
  @spec create_room(attrs :: map | nil) :: {:ok, Room.t()} | {:error, Ecto.Changeset.t()}
  def create_room(attrs \\ %{}) do
    %Room{}
    |> Room.creation_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a room.
  """
  @spec update_room(room :: Room.t(), attrs :: map) ::
          {:ok, Room.t()} | {:error, Ecto.Changeset.t()}
  def update_room(%Room{} = room, attrs) do
    room
    |> Room.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a room.
  """
  @spec delete_room(room :: Room.t()) :: {:ok, Room.t()} | {:error, Ecto.Changeset.t()}
  def delete_room(%Room{} = room) do
    Repo.delete(room)
  end

  @doc """
  Add a vote option to a room.
  """
  @spec add_vote_option(room :: Room.t(), attrs :: map) ::
          {:ok, Room.t()} | {:error, Ecto.Changeset.t()}
  def add_vote_option(room, attrs) do
    Ecto.build_assoc(room, :vote_options)
    |> VoteOption.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Delete a vote option.
  """
  @spec delete_vote_option!(VoteOption.t()) :: VoteOption.t() | no_return()
  def delete_vote_option!(vote_option) do
    Repo.delete!(vote_option)
  end

  @doc """
  Use this changeset to update an existing room.
  """
  defdelegate room_changeset(room, attrs), to: Room, as: :changeset

  @doc """
  Use this changeset when creating a new room. A room requires users, and this
  changeset ensures that a user for the room is created alongside of it.
  """
  defdelegate room_creation_changeset(new_room, attrs), to: Room, as: :creation_changeset

  @doc """
  Use this to make changes to a VoteOption.
  """
  defdelegate vote_option_changeset(vote_option, attrs), to: VoteOption, as: :changeset
end
