defmodule VotrWeb.VoteLive.VoteCasting do
  use VotrWeb, :live_component
  alias Votr.Voting

  def render(assigns) do
    VotrWeb.VoteView.render("vote_casting.html", assigns)
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

  # def handle_event(
  #       "move_vote",
  #       %{"from" => from, "to" => to, "voteOptionId" => option_id},
  #       socket
  #     ) do
  #   option_id = String.to_integer(option_id)
  #   from = parse_location(from)
  #   to = parse_location(to)

  #   option =
  #     socket.assigns.vote_options
  #     |> Enum.find(fn vo -> vo.id == option_id end)

  #   options_by_rank =
  #     socket.assigns.options_by_rank
  #     |> Map.update!(from, &Enum.reject(&1, fn vo -> vo.id == option_id end))
  #     |> Map.update!(to, &(&1 ++ [option]))

  #   {:noreply, assign(socket, options_by_rank: options_by_rank)}
  # # end

  # def handle_event(up_or_down, %{"id" => id}, socket) when up_or_down in ~w|up down| do
  #   id = String.to_integer(id)

  #   update_vote_option = fn vos ->
  #     import Access
  #     len = length(vos)

  #     op =
  #       case up_or_down do
  #         "up" -> &max(&1 - 1, 1)
  #         "down" -> &min(&1 + 1, len)
  #       end

  #     i = Enum.find_index(vos, &(&1.id == id))

  #     update_in(vos, [at(i), key(:rank)], op)
  #   end

  #   room = Map.update!(socket.assigns.room, :vote_options, update_vote_option)

  #   {:noreply, assign(socket, room: room)}
  # end

  # defp parse_location("menu"), do: :menu
  # defp parse_location(str), do: String.to_integer(str)
end
