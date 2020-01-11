defmodule Votr.Voting.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "voting_users" do
    field :name, :string

    belongs_to :room, Votr.Voting.Room

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :room_id])
    |> assoc_constraint(:room)
    |> validate_required([:name])
    |> validate_length(:name, min: 2)
    |> validate_at_least_n_letters(:name, 2)
  end

  defp validate_at_least_n_letters(changeset, field, n) when n > 0 do
    str = get_field(changeset, field) || ""
    valid? = String.replace(str, ~r/[^a-z]/i, "") |> String.length() >= 2

    if valid? do
      changeset
    else
      add_error(changeset, field, "should have at least #{n} letter(s)")
    end
  end
end
