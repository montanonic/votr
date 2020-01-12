defmodule Votr.Voting.VoteOption do
  use Ecto.Schema
  import Ecto.Changeset

  schema "vote_options" do
    field :description, :string
    field :name, :string

    belongs_to :room, Votr.Voting.Room

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = vote_option, attrs) do
    vote_option
    |> cast(attrs, [:name, :description])
    |> validate_required([:name])
    |> assoc_constraint(:room)
    |> unsafe_validate_unique([:name, :room_id], Votr.Repo)
    |> unique_constraint(:name, name: :vote_options_room_id_name_index)
  end
end
