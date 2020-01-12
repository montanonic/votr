defmodule VotrWeb.VoteLive.VoteOptions do
  use VotrWeb, :live_component
  alias Votr.Voting
  alias Votr.Voting.VoteOption
  alias VotrWeb.VoteLive

  def render(assigns) do
    VotrWeb.VoteView.render("vote_options.html", assigns)
  end

  def mount(socket) do
    {:ok, assign(socket, changeset: initial_changeset(), editing_option_id: nil)}
  end

  def update(%{room: room}, socket) do
    {:ok, assign(socket, room: room)}
  end

  def handle_event("validate", %{"vote_option" => vote_option_params}, socket) do
    changeset =
      %VoteOption{}
      |> Voting.vote_option_changeset(vote_option_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"vote_option" => vote_option_params}, socket) do
    result = case Voting.add_vote_option(socket.assigns.room, vote_option_params) do
      {:ok, vote_option} ->
        VoteLive.broadcast!(socket, {:added_vote_option, vote_option})
        {:noreply, assign(socket, changeset: initial_changeset())}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
    Process.sleep(500)
    result
  end

  def handle_event("edit_option", %{"id" => id}, socket) do
    id = String.to_integer(id)
    {:noreply, assign(socket, editing_option_id: id)}
  end

  def handle_event("delete_option", %{"id" => id}, socket) do
    id = String.to_integer(id)
    vote_option = socket.assigns.room.vote_options |> Enum.find(&(&1.id == id))
    Voting.delete_vote_option!(vote_option)
    IO.puts("DELETED")
    VoteLive.broadcast!(socket, {:removed_vote_option, vote_option})
    {:noreply, socket}
  end

  def handle_event(msg, params, socket) do
    IO.inspect(msg, label: "MESSAGE")
    IO.inspect(params, label: "PARAMS")
    {:noreply, socket}
  end

  defp initial_changeset, do: Voting.vote_option_changeset(%VoteOption{}, %{})
end
