defmodule VotrWeb.RoomLive.New do
  use VotrWeb, :live_view

  alias Votr.Voting
  alias Votr.Voting.{Room, User}

  @impl true
  def render(assigns) do
    VotrWeb.RoomView.render("new.html", assigns)
  end

  @impl true
  def mount(_session, socket) do
    changeset = Room.creation_changeset(%Room{}, %{})
    {:ok, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event("validate", %{"room" => room_params}, socket) do
    IO.inspect socket, structs: false
    changeset =
      %Room{}
      |> Room.creation_changeset(room_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"room" => room_params}, socket) do
    socket =
      case Voting.create_room(room_params) do
        {:ok, room} ->
          # Make user feel like something is happening.
          Process.sleep(700)
          IO.inspect(room, label: "NEW ROOM")
          # VotrWeb.Presence.track(self(), "vote", user.id, %{name: user.name})
          live_redirect(socket, to: Routes.live_path(socket, VotrWeb.RoomLive.Show, room.id))

        {:error, changeset} ->
          assign(socket, changeset: changeset)
      end

    {:noreply, socket}
  end

  def handle_event(event, _, socket) do
    IO.inspect(event, label: "EVENT")
    {:noreply, socket}
  end
end
