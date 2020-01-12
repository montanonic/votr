defmodule VotrWeb.VoteView do
  use VotrWeb, :view
  alias VotrWeb.VoteLive
  alias Votr.Voting.{VoteOption}

  def num_vote_options(room) do
    room.vote_options |> Enum.count()
  end
end
