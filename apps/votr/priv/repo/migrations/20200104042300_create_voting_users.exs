defmodule Votr.Repo.Migrations.CreateVotingUsers do
  use Ecto.Migration

  def change do
    create table(:voting_users) do
      add :name, :string, null: false
      add :room_id, references(:rooms, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:voting_users, [:room_id])
  end
end
