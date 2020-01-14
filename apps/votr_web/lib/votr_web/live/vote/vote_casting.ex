defmodule VotrWeb.VoteLive.VoteCasting do
  use VotrWeb, :live_component
  alias Votr.Voting

  def render(assigns) do
    VotrWeb.VoteView.render("vote_casting.html", assigns)
  end

  def handle_event("cancel_voting", _params, socket) do
    Voting.set_room_status(socket.assigns.room, "voting_options")
    {:noreply, socket}
  end
end
