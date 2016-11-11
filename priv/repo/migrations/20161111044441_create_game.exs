defmodule Gamedex.Repo.Migrations.CreateGame do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :name, :string
    end

    create index(:games, [:name], unique: true)
  end
end
