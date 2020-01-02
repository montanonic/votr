defmodule Votr.Voting.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Votr.Voting.User

  @primary_key {:id, :binary_id, autogenerate: false}

  embedded_schema do
    field :name, :string
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> validate_length(:name, min: 2)
    |> put_change(:id, Ecto.UUID.generate())
  end

  def new(attrs) do
    %User{}
    |> changeset(attrs)
    |> apply_action(:insert)
  end
end
