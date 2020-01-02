defmodule Votr.Voting do
  alias Ecto.Changeset
  alias Votr.Voting.{Room, User}

  def change_room(%Room{} = room, attrs \\ %{}) do
    Room.changeset(room, attrs)
  end

  @doc """
  Creates a room with the given attributes, returning `{:ok, room, user}` giving
  the user that created the room as well, or `{:error, changeset}` in the case
  of failure.
  """
  def create_room(attrs) do
    with {:ok, room} <- Room.new(attrs) do
      Votr.Store.put(room)
      {:ok, room, hd(room.users)}
    end
  end

  # @doc """
  # Joins a room as a user.
  # """
  # def join_room(%Room{} = room, user_attrs), do: add_user(room.id, attrs)

  # def join_room(room_id, user_attrs) do
  #   Votr.
  # end
end
