defmodule VotrWeb.RoomLive.Show do
  use VotrWeb, :live_view

  alias Votr.Voting

  @impl true
  def render(assigns) do
    VotrWeb.RoomView.render("show.html", assigns)
  end

  @impl true
  def mount(_session, socket) do
    {:ok, assign(socket, [])}
  end

  @impl true
  def handle_params(%{"id" => id}, _uri, socket) do
    room = Voting.get_room!(id, preload: :users)
    {:noreply, assign(socket, room: room)}
  end

  @impl true
  def handle_event(event, _, socket) do
    IO.inspect event, label: "EVENT"
    {:noreply, socket}
  end
end
