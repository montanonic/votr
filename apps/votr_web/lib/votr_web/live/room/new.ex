defmodule VotrWeb.RoomLive.New do
  use VotrWeb, :live_view

  alias Votr.Voting
  alias Votr.Voting.{Room, User}

  @impl true
  def render(assigns) do
    ~L""
    # VotrWeb.RoomView.render("new.html", assigns)
  end

  @impl true
  def mount(_session, socket) do
    changeset =  %{} # Votr.Voting.change_room(%Room{users: [%User{}]})
    {:ok, assign(socket, count: 0, changeset: changeset)}
  end

  # @impl true
  # def handle_event("validate", %{"room" => room_params}, socket) do
  #   changeset =
  #     %Room{}
  #     |> Votr.Voting.change_room(room_params)
  #     |> Map.put(:action, :insert)

  #   {:noreply, assign(socket, changeset: changeset)}
  # end

  # def handle_event("save", %{"room" => room_params}, socket) do
  #   socket =
  #     case Voting.create_room(room_params) do
  #       {:ok, room, user} ->
  #         Process.sleep(700) # Make user feel like something is happening.
  #         VotrWeb.Presence.track(self(), "vote", user.id, %{name: user.name})
  #         require IEx; IEx.pry()
  #         socket

  #       {:error, changeset} ->
  #         assign(socket, changeset: changeset)
  #     end

  #   {:noreply, socket}
  # end
end
