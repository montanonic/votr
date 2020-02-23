
alias VotrWeb.Endpoint
alias Votr.Repo
alias Votr.Voting
alias Votr.Voting.{User, Room, VoteOption}

alias Ecto.Changeset
alias Ecto.Query

# TEMP
alias VotrWeb.VoteLive.VoteCasting.VoteOptionRanking

vor = VoteOptionRanking

vote_options = [%{id: 0, name: "Sanders"}, %{id: 1, name: "Warren"}, %{id: 2, name: "Biden"}]

run_test = fn ->
  state = VoteOptionRanking.new(vote_options)

  IO.puts "Moving to an out of bounds location should fail:"
  IO.inspect VoteOptionRanking.move(state, 1, 4, 0)
  IO.inspect VoteOptionRanking.move(state, 1, 0, 0)

  IO.puts "Moving to an out of bounds index should fail:"
  IO.inspect VoteOptionRanking.move(state, 1, 1, 10)

  IO.puts "Moving to a good location and index should work (rank 1 position 0):"
  IO.inspect VoteOptionRanking.move(state, 1, 1, 0)
  :ok
end
