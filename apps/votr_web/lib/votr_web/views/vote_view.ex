defmodule VotrWeb.VoteView do
  use VotrWeb, :view
  alias VotrWeb.VoteLive
  alias Votr.Voting.Room

  def num_vote_options(vote_options) do
    vote_options |> Enum.count()
  end

  @doc """
  Returns vote options in a room in descending sort by insertion time (newest
  first). This ensures a stable order across page loads.
  """
  def sorted_vote_options(vote_options) do
    vote_options |> Enum.sort_by(& &1.inserted_at, &>=/2)
  end

  @doc """
  Renders votes in the order given by the user.
  """
  def sort_votes_by_rank(vote_options) do
    vote_options |> Enum.sort_by(& &1.rank, &<=/2)
  end
end
