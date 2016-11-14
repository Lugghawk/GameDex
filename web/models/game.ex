defmodule Gamedex.Game do
  use Gamedex.Web, :model

  alias Gamedex.Repo

  schema "games" do
    field :name, :string

    many_to_many :users, Gamedex.User, join_through: "users_games"
  end

  @required_fields ~w(name)a

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
  end
end

