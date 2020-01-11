defmodule VotrWeb.VoteLive do
  use VotrWeb, :live_view

  # alias Votr.Voting

  @impl true
  def render(assigns) do
    VotrWeb.VoteView.render("main.html", assigns)
  end

  @impl true
  def mount(_session, socket) do
    {:ok, assign(socket, [])}
  end
end
