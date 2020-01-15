defmodule VotrWeb.VoteLive.VoteCasting do
  use VotrWeb, :live_component
  alias Votr.Voting

  def render(assigns) do
    VotrWeb.VoteView.render("vote_casting.html", assigns)
  end

  def mount(socket) do
    {:ok, assign(socket, vote_options: %{})}
  end

  def update(assigns, socket) do
    assigns =
      update_in(assigns.room.vote_options, fn vote_options ->
        vote_options
        |> Enum.map(fn vo -> Map.put_new(vo, :rank, 1) end)
      end)

    {:ok, assign(socket, assigns)}
  end

  def handle_event("cancel_voting", _params, socket) do
    Voting.set_room_status(socket.assigns.room, "voting_options")
    {:noreply, socket}
  end

  def handle_event(up_or_down, %{"id" => id}, socket) when up_or_down in ~w|up down| do
    id = String.to_integer(id)

    update_vote_option = fn vos ->
      import Access
      len = length(vos)

      op =
        case up_or_down do
          "up" -> &max(&1 - 1, 1)
          "down" -> &min(&1 + 1, len)
        end

      i = Enum.find_index(vos, &(&1.id == id))

      update_in(vos, [at(i), key(:rank)], op)
    end

    room = Map.update!(socket.assigns.room, :vote_options, update_vote_option)

    {:noreply, assign(socket, room: room)}
  end
end
