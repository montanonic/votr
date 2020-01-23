defmodule Votr.Voting.Vote do
  use Ecto.Schema
  import Ecto.Changeset

  schema "room_votes" do
    field :rank, :integer
    field :room_id, :id
    field :user_id, :id
    field :vote_option_id, :id

    timestamps()
  end

  @doc false
  def changeset(vote, attrs) do
    vote
    |> cast(attrs, [:rank])
    |> validate_required([:rank])
  end
end
