defmodule Gamedex.Game do
  use Gamedex.Web, :model

  alias Gamedex.Repo

  schema "games" do
    field :name, :string

  end

  @required_fields ~w(name)a

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
  end
end

