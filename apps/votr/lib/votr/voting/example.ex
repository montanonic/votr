# defmodule App.Rooms.Room do
#   use Ecto.Schema
#   import Ecto.Changeset

#   schema "rooms" do
#     field :name, :string

#     has_many :users, App.Rooms.User
#   end

#   @doc false
#   def changeset(room, attrs) do
#     room
#     |> cast(attrs, [:name])
#     |> cast_assoc(:users, required: true)
#     |> validate_required([:name, :users])
#     |> validate_length(:users, min: 1)
#   end
# end

# defmodule App.Rooms.User do
#   use Ecto.Schema
#   import Ecto.Changeset

#   schema "room_users" do
#     field :name, :string

#     belongs_to :room, App.Rooms.Room
#   end

#   @doc false
#   def changeset(user, attrs) do
#     user
#     |> cast(attrs, [:name, :room_id])
#     |> assoc_constraint(:room)
#     |> validate_required([:name, :room_id])
#   end
# end
