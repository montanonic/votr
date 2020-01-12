# defmodule VotrWeb.RoomController do
#   use VotrWeb, :controller

#   alias Votr.Voting
#   alias Votr.Voting.Room
#   alias Votr.Voting.User

#   def index(conn, _params) do
#     rooms = Voting.list_rooms()
#     render(conn, "index.html", rooms: rooms)
#   end

#   def login(conn, _params) do
#     live_render(conn, VotrWeb.RoomLive.New, router: VotrWeb.Router)
#   end


#   def logout(conn, _params) do
#     live_render(conn, VotrWeb.RoomLive.New, router: VotrWeb.Router)
#   end

#   def new(conn, _params) do
#     changeset = Voting.change_room(%Room{users: [%User{}]})
#     render(conn, "new.html", changeset: changeset)
#   end

#   def new_user(conn, %{"id" => room_id}) do
#     changeset = Voting.change_user(%User{})
#     render(conn, "new_user.html", changeset: changeset, room_id: room_id)
#   end

#   def create(conn, %{"room" => room_params}) do
#     case Voting.create_room(room_params) do
#       {:ok, room} ->
#         conn
#         |> put_flash(:info, "Room created successfully.")
#         |> redirect(to: Routes.room_path(conn, :show, room))

#       {:error, %Ecto.Changeset{} = changeset} ->
#         render(conn, "new.html", changeset: changeset)
#     end
#   end

#   def create_user(conn, %{"id" => room_id, "user" => user_params}) do
#     user_params = Map.put(user_params, "room_id", room_id)

#     case Voting.create_user(user_params) do
#       {:ok, _user} ->
#         conn
#         |> put_flash(:info, "User joined room successfully.")
#         |> redirect(to: Routes.room_path(conn, :show, room_id))

#       {:error, %Ecto.Changeset{} = changeset} ->
#         if changeset.errors[:room] do
#           put_flash(conn, :error, "Tried to join a room that doesn't exist.")
#         else
#           conn
#         end
#         |> render("new_user.html", changeset: changeset, room_id: room_id)
#     end
#   end

#   def show(conn, %{"id" => id}) do
#     room = Voting.get_room!(id, preload: [:users])
#     render(conn, "show.html", room: room)
#   end

#   def edit(conn, %{"id" => id}) do
#     room = Voting.get_room!(id)
#     changeset = Voting.change_room(room)  #|> Ecto.Changeset.put_change(:users, [])
#     render(conn, "edit.html", room: room, changeset: changeset)
#   end

#   def update(conn, %{"id" => id, "room" => room_params}) do
#     room = Voting.get_room!(id)

#     case Voting.update_room(room, room_params) do
#       {:ok, room} ->
#         conn
#         |> put_flash(:info, "Room updated successfully.")
#         |> redirect(to: Routes.room_path(conn, :show, room))

#       {:error, %Ecto.Changeset{} = changeset} ->
#         render(conn, "edit.html", room: room, changeset: changeset)
#     end
#   end

#   def delete(conn, %{"id" => id}) do
#     room = Voting.get_room!(id)
#     {:ok, _room} = Voting.delete_room(room)

#     conn
#     |> put_flash(:info, "Room deleted successfully.")
#     |> redirect(to: Routes.room_path(conn, :index))
#   end
# end
