defmodule VotrWeb.VoteLive do
  use VotrWeb, :live_view
  alias Votr.Voting

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
    topic = vote_topic(socket)

    if connected?(socket) do
      # In case of param change, we don't want to subscribe to multiple rooms at once.
      :ok = PubSub.unsubscribe(VotrWeb.PubSub, topic)
      :ok = PubSub.subscribe(VotrWeb.PubSub, topic)
    end

    {:noreply, socket}
  end

  @doc false
  @impl true
  def handle_info({:added_vote_option, vote_option}, socket) do
    room = Map.update!(socket.assigns.room, :vote_options, &[vote_option | &1])
    {:noreply, assign(socket, room: room)}
  end

  def handle_info({:removed_vote_option, vote_option}, socket) do
    room = Map.update!(socket.assigns.room, :vote_options, &List.delete(&1, vote_option))
    {:noreply, assign(socket, room: room)}
  end

  @doc """
  Broadcast a message to everyone rendering the VotrLive view.
  """
  def broadcast!(socket, msg) do
    PubSub.broadcast!(VotrWeb.PubSub, vote_topic(socket), msg)
  end

  # Returns the topic for the current room's voting session. Expects that the
  # `room` is assigned to the `socket`.
  defp vote_topic(%{assigns: %{room: %{id: id}}}), do: "voting_room:#{id}"
end
