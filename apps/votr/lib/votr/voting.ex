defmodule Votr.Voting do
  @moduledoc """
  The Voting context.
  """

  import Ecto.Query, warn: false
  import Ecto.Changeset, warn: false
  alias Votr.Repo
  alias Votr.Voting.{VoteOption, Room}

  #
  # Room
  #

  @doc """
  Returns the list of rooms.

  ## Examples

      iex> list_rooms()
      [%Room{}, ...]

  """
  def list_rooms do
    Repo.all(Room)
  end

  # @doc """
  # Returns rooms that a user is a part of (has joined).
  # """
  # def list_rooms_user_is_in(_user \\ nil) do
  #   query = from r in Room,
  #     right_join: u in assoc(r, :users),
  #     select: [r, u]
  #   Repo.all(query)
  # end

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
  @spec create_room(attrs :: map) :: {:ok, Room.t()} | {:error, Ecto.Changeset.t()}
  def create_room(attrs) do
    %Room{}
    |> Room.creation_changeset(attrs)
    |> put_change(:status, Room.get_status("voting_options"))
    |> Repo.insert()
    |> broadcast_change!({Room, :created})
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
    |> broadcast_change!({Room, :updated})
  end

  @doc """
  Sets a room's status, changing how it behaves.
  """
  def set_room_status(room, status) do
    room
    |> change(%{status: Room.get_status(status)})
    |> Repo.update!()
    |> broadcast_change!({Room, :status_changed})
  end

  @doc """
  Deletes a room.
  """
  @spec delete_room(room :: Room.t()) :: {:ok, Room.t()} | {:error, Ecto.Changeset.t()}
  def delete_room(%Room{} = room) do
    Repo.delete(room)
    |> broadcast_change!({Room, :deleted})
  end

  #
  # VoteOption
  #

  @doc """
  Retrieves vote options for a room.
  """
  def list_vote_options(room) do
    Repo.all(Ecto.assoc(room, :vote_options))
  end

  @doc """
  Add a vote option to a room.
  """
  @spec add_vote_option(room :: Room.t(), attrs :: map) ::
          {:ok, VoteOption.t()} | {:error, Ecto.Changeset.t()}
  def add_vote_option(room, attrs) do
    Ecto.build_assoc(room, :vote_options)
    |> VoteOption.changeset(attrs)
    |> Repo.insert()
    |> broadcast_change!({VoteOption, :added})
  end

  @doc """
  Delete a vote option.
  """
  @spec delete_vote_option!(VoteOption.t()) :: VoteOption.t() | no_return()
  def delete_vote_option!(vote_option) do
    Repo.delete!(vote_option)
    |> broadcast_change!({VoteOption, :deleted})
  end

  #
  # Changeset
  #

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

  #
  # PubSub
  #

  # When data is changed, this function broadcasts that changed data to all
  # subscribers. This took a surprisingly long time to generalize so that it'd
  # work with (1) changesets and non-changesets, (2) Room structs and structs
  # with room_id's, (3) structs that have no reference to the current room
  # (requiring that you manually pass the room_id to the function). The
  # end-result is that this function preserves the given data, returning it
  # as-is, while also broadcasting an event for the room using any inference
  # from the given data with any successful changeset.
  defp broadcast_change!(result, event) do
    # This two-clause version of the function tries to extract the room's id
    # from the given result, passing it to the more general broadcast_change!/3
    # function. If your result wouldn't match a room id in the cases below,
    # you'll need to manually pass the room_id as the second argument to
    # broadcast_change!/3.
    room_id =
      case result do
        {:ok, %Room{id: id}} -> id
        {:ok, %{room_id: id}} -> id
        %Room{id: id} -> id
        %{room_id: id} -> id
        {:error, _} -> nil
      end

    broadcast_change!(result, room_id, event)
  end

  defp broadcast_change!({:ok, result}, room_id, event),
    do: broadcast_change!(result, room_id, event, :ok)

  defp broadcast_change!({:error, result}, _, _), do: result

  defp broadcast_change!(%{} = result, room_id, event),
    do: broadcast_change!(result, room_id, event, nil)

  defp broadcast_change!(result, room_id, event, wrapper) do
    broadcast_to_room!(result, room_id, event)

    if wrapper do
      {wrapper, result}
    else
      result
    end
  end

  # Broadcasts an event message to anyone subscribing to the current room.
  defp broadcast_to_room!(result, room_id, event) do
    Phoenix.PubSub.broadcast!(VotrWeb.PubSub, pubsub_topic(room_id), {__MODULE__, event, result})
  end

  defp pubsub_topic(room_id), do: "#{inspect(__MODULE__)}:#{room_id}"

  @doc """
  Subscribe to Voting events for a room.
  """
  def subscribe(room_id) do
    Phoenix.PubSub.subscribe(VotrWeb.PubSub, pubsub_topic(room_id))
  end

  @doc """
  Unsubscribe from Voting events for a room.
  """
  def unsubscribe(room_id) do
    Phoenix.PubSub.unsubscribe(VotrWeb.PubSub, pubsub_topic(room_id))
  end
end
