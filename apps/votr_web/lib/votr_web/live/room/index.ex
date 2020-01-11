defmodule VotrWeb.RoomLive.Index do
  use VotrWeb, :live_view

  alias Votr.Voting

  @impl true
  def render(assigns) do
    VotrWeb.RoomView.render("index.html", assigns)
  end

  @impl true
  def mount(_session, socket) do
    rooms = Voting.list_rooms()
    {:ok, assign(socket, rooms: rooms)}
  end
end
