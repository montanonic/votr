defmodule VotrWeb.VoteLive.VoteCasting do
  use VotrWeb, :live_component
  alias Votr.Voting

  def render(assigns) do
    VotrWeb.VoteView.render("vote_casting.html", assigns)
  end

  def mount(socket) do
    {:ok, assign(socket, validating?: false)}
  end

  def update(assigns, socket) do
    m(%{vote_options, room}) = assigns

    options_by_rank =
      vote_options
      |> Stream.with_index(1)
      |> Enum.into(%{}, fn {_, i} -> {i, []} end)
      |> Map.put(:menu, vote_options)

    {:ok,
     assign(socket,
       room: room,
       vote_options: vote_options,
       options_by_rank: options_by_rank
     )}
  end

  def handle_event("cancel_voting", _params, socket) do
    Voting.set_room_status(socket.assigns.room.id, "voting_options")
    {:noreply, socket}
  end

  def handle_event("confirm_submission", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("edit_submission", _params, %{assigns: m(%{validating?})} = socket)
      when validating? do
    {:noreply, assign(socket, validating?: false)}
  end

  def handle_event("submit_votes", _params, socket) do
    IO.inspect(socket.assigns.options_by_rank)
    {:noreply, assign(socket, validating?: true)}
  end

  def handle_event("move_vote", params, socket) do
    ms(%{from, to, new_index, option_id}) = params
    m(%{vote_options, options_by_rank}) = socket.assigns

    vote_option = Enum.find(vote_options, &(&1.id == option_id))

    options_by_rank =
      options_by_rank
      |> Map.update!(parse_rank(from), &Enum.reject(&1, fn m(%{id}) -> id == option_id end))
      |> Map.update!(parse_rank(to), &List.insert_at(&1, new_index, vote_option))

    {:noreply, assign(socket, mk(%{options_by_rank}))}
  end

  defp parse_rank("menu"), do: :menu
  defp parse_rank(str), do: String.to_integer(str)
end
