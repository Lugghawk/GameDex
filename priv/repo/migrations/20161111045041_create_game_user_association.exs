defmodule Gamedex.Repo.Migrations.CreateGameUserAssociation do
  use Ecto.Migration

  def change do
    create table(:users_games) do
      add :game_id, :integer
      add :user_id, :integer
    end

    create index(:users_games, [:user_id], unique: false)
  end
end
