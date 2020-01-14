defmodule VotrWeb.VoteLive do
  use VotrWeb, :live_view
  alias Votr.Voting
  alias Votr.Voting.{VoteOption, Room}

  @doc false
  @impl true
  def render(assigns) do
    VotrWeb.VoteView.render("main.html", assigns)
  end

  @doc false
  @impl true
  def mount(_session, socket) do
    {:ok, assign(socket, [])}
  end

  @doc false
  @impl true
  def handle_params(%{"id" => id}, _uri, socket) do
    room = Voting.get_room!(id, preload: [:users, :vote_options])
    socket = assign(socket, room: room)

    if connected?(socket) do
      room_id = socket.assigns.room.id
      # In case of param change, we only want to be subscribed to a single room.
      :ok = Voting.unsubscribe(room_id)
      :ok = Voting.subscribe(room_id)
    end

    {:noreply, socket}
  end

  @doc false
  @impl true
  def handle_info({Voting, {VoteOption, :added}, vote_option}, socket) do
    room = Map.update!(socket.assigns.room, :vote_options, &[vote_option | &1])
    {:noreply, assign(socket, room: room)}
  end

  def handle_info({Voting, {VoteOption, :deleted}, vote_option}, socket) do
    room = Map.update!(socket.assigns.room, :vote_options, &List.delete(&1, vote_option))
    {:noreply, assign(socket, room: room)}
  end

  def handle_info({Voting, {Room, :status_changed}, room}, socket) do
    {:noreply, assign(socket, room: room)}
  end

  def handle_info({Voting, event, _result}, socket) do
    IO.inspect event, label: "Unhandled Voting Event"
    {:noreply, socket}
  end
end
