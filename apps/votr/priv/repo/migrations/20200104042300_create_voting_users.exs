defmodule Votr.Repo.Migrations.CreateVotingUsers do
  use Ecto.Migration

  def change do
    create table(:voting_users) do
      add :name, :string, null: false
      add :room_id, references(:rooms, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:voting_users, [:room_id])
    create unique_index(:voting_users, [:room_id, :name])
  end
end
