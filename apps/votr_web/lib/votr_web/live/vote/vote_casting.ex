defmodule VotrWeb.VoteLive.VoteCasting do
  use VotrWeb, :live_component
  alias Votr.Voting
  alias Votr.Voting.VoteOption

  def render(assigns) do
    VotrWeb.VoteView.render("vote_casting.html", assigns)
  end

  def mount(socket) do
    {:ok, assign(socket, validating?: false)}
  end

  def update(assigns, socket) do
    m(%{vote_options, room}) = assigns

    # `:ranked` keeps track of the options that have been ranked.
    options_by_rank =
      vote_options
      |> Stream.with_index(1)
      |> Enum.into(%{}, fn {_, i} -> {i, []} end)
      |> Map.put(:menu, vote_options)
      |> Map.put(:ranked, MapSet.new())

    {:ok, assign(socket, mk(%{room, vote_options, options_by_rank}))}
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
    Process.sleep(2000)
    ms(%{from, to, new_index, option_id}) = params
    m(%{vote_options, options_by_rank}) = socket.assigns

    vote_option = Enum.find(vote_options, &(&1.id == option_id))

    options_by_rank =
      options_by_rank
      |> remove_from_group(from, option_id)
      |> add_to_group(to, new_index, vote_option)

    IO.inspect(
      update_in(
        options_by_rank |> Enum.to_list(),
        [Access.all(), Access.elem(1), Access.all()],
        & &1.name
      )
      |> Enum.into(%{})
    )

    {:noreply, assign(socket, mk(%{options_by_rank}))}
  end

  defp remove_from_group(options_by_rank, group, option_id) do
    map =
      Map.update!(
        options_by_rank,
        group,
        &Enum.reject(&1, fn m(%{id}) -> id == option_id end)
      )

    update_fn = get_update_ranked_fn((group == :menu && :ranked) || :unranked, option_id)

    Map.update!(map, :ranked, update_fn)
  end

  defp add_to_group(options_by_rank, group, index, %VoteOption{} = vote_option) do
    map =
      Map.update!(
        options_by_rank,
        group,
        &List.insert_at(&1, index, vote_option)
      )

    update_fn = get_update_ranked_fn((group != :menu && :ranked) || :unranked, vote_option.id)

    Map.update!(map, :ranked, update_fn)
  end

  defp get_update_ranked_fn(:ranked, option_id), do: &MapSet.put(&1, option_id)
  defp get_update_ranked_fn(:unranked, option_id), do: &MapSet.delete(&1, option_id)

  defp parse_rank("menu"), do: :menu
  defp parse_rank(str), do: String.to_integer(str)

  defmodule VoteOptionRanking do
    @moduledoc """
    Holds UI-relevant data for VoteOptions.

    The following fields are internal use only, but are described here to
    facilitate development of this module.

    * `vote_options_by_id`: The actual vote_option data, organized for lookup by
      id.
    * `id_to_location`: Where the vote_option is at, either in a group or in the
      menu.
    * `id_to_index`: What the index of the vote_option is at its given location.
    """

    @struct_fields [vote_option_by_id: %{}, id_to_location: %{}, id_to_index: %{}]

    # @derive {Inspect, only: []}
    # Enforce all keys.
    @enforce_keys Enum.map(@struct_fields, &elem(&1, 0))
    defstruct vote_option_by_id: %{}, id_to_location: %{}, id_to_index: %{}

    def new(vote_options) do
      vote_option_by_id = Enum.into(vote_options, %{}, &{&1.id, &1})

      id_to_location = Enum.into(vote_options, %{}, &{&1.id, :menu})

      id_to_index =
        vote_options
        |> Stream.with_index()
        |> Enum.into(%{}, fn {%{id: id}, idx} -> {id, idx} end)

      m(%__MODULE__{vote_option_by_id, id_to_location, id_to_index})
    end

    def num_options(%__MODULE__{} = self) do
      m(%{vote_options_by_id}) = self
      map_size(vote_options_by_id)
    end
  end
end
