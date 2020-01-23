defmodule VotrWeb.VoteLive.VoteOptions do
  use VotrWeb, :live_component
  alias Votr.Voting
  alias Votr.Voting.VoteOption

  def render(assigns) do
    VotrWeb.VoteView.render("vote_options.html", assigns)
  end

  def mount(socket) do
    {:ok, assign(socket, changeset: initial_changeset(), editing_option_id: nil)}
  end

  def handle_event("validate", %{"vote_option" => vote_option_params}, socket) do
    changeset =
      %VoteOption{}
      |> Voting.vote_option_changeset(vote_option_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"vote_option" => vote_option_params}, socket) do
    result =
      case Voting.add_vote_option(socket.assigns.room, vote_option_params) do
        {:ok, _vote_option} ->
          {:noreply, assign(socket, changeset: initial_changeset())}

        {:error, changeset} ->
          {:noreply, assign(socket, changeset: changeset)}
      end

    # Prevent spam.
    Process.sleep(50)
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
    {:noreply, socket}
  end

  def handle_event("start_vote", _params, socket) do
    Voting.set_room_status(socket.assigns.room, "voting")
    {:noreply, socket}
  end

  defp initial_changeset, do: Voting.vote_option_changeset(%VoteOption{}, %{})
end
