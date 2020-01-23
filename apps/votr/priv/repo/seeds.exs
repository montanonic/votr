# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Votr.Repo.insert!(%Votr.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# import Ecto.{Query, Changeset}
alias Votr.Voting

Application.put_env(:votr, :seeding, true)

users =
  for char1 <- ~w'A B C', char2 <- ~w'a b', do: %{name: List.to_string([char1, char2, char2])}

rooms = for n <- 1..3, do: Voting.create_room(%{id: n, name: "Room #{n}", users: users})

options = ~w|Pizza Cake Fries Shake Burger|

for option <- options, {:ok, room} <- rooms, do: Voting.add_vote_option(room, %{name: option})
