defmodule VotrWeb.VoteLive do
  use VotrWeb, :live_view
  alias Votr.Voting
  alias Votr.Voting.{VoteOption, Room}

  @impl true
  def render(assigns) do
    VotrWeb.VoteView.render("main.html", assigns)
  end

  @impl true
  def handle_params(%{"id" => id}, _uri, socket) do
    room = Voting.get_room!(id)
    vote_options = Voting.list_vote_options(room)

    socket = assign(socket, mk(%{room, vote_options}))

    if connected?(socket) do
      # In case of param change, we only want to be subscribed to a single room.
      :ok = Voting.unsubscribe(room.id)
      :ok = Voting.subscribe(room.id)
    end

    {:noreply, socket}
  end

  @impl true
  def handle_info({Voting, {VoteOption, :added}, vote_option}, socket) do
    {:noreply, assign(socket, vote_options: [vote_option | socket.assigns.vote_options])}
  end

  def handle_info({Voting, {VoteOption, :deleted}, vote_option}, socket) do
    {:noreply,
     assign(socket,
       vote_options:
         Enum.reject(socket.assigns.vote_options, fn vo -> vo.id == vote_option.id end)
     )}
  end

  def handle_info({Voting, {Room, :status_changed}, room}, socket) do
    {:noreply, assign(socket, room: room)}
  end

  def handle_info({Voting, event, _result}, socket) do
    IO.inspect(event, label: "Unhandled Voting Event")
    {:noreply, socket}
  end
end
