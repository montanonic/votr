defmodule Votr.Repo.Migrations.CreateRoomVotes do
  use Ecto.Migration

  def change do
    create table(:room_votes) do
      add :rank, :integer, null: false
      add :room_id, references(:rooms, on_delete: :nothing), null: false
      add :user_id, references(:voting_users, on_delete: :nothing), null: false
      add :vote_option_id, references(:vote_options, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:room_votes, [:room_id])
    create index(:room_votes, [:user_id])
    create index(:room_votes, [:vote_option_id])
    create unique_index(:room_votes, [:room_id, :user_id, :vote_option_id])
  end
end
