defmodule Votr.Repo.Migrations.CreateVoteOptions do
  use Ecto.Migration

  def change do
    create table(:vote_options) do
      add :name, :string, null: false
      add :description, :text
      add :room_id, references(:rooms, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:vote_options, [:room_id])
    create unique_index(:vote_options, [:room_id, :name])
  end
end
