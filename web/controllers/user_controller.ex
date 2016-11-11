defmodule Gamedex.UserController do
  use Gamedex.Web, :controller

  alias Gamedex.Repo
  alias Gamedex.User
  alias Gamedex.Authorization
  alias Gamedex.Game

  def new(conn, params, current_user, _claims) do
    render conn, "new.html", current_user: current_user
  end

  def update(conn, params, current_user, _claims) do
    IO.inspect params
    IO.inspect current_user
    conn
  end

  def add_game(conn, %{"update" => %{"added_game" => game_added} }, current_user, _claims) do
    query = from g in Game, where: g.id == ^game_added
    game = Repo.one(query)
    changeset = Repo.preload(current_user, :games)
    |> User.changeset(%{})
    |> Ecto.Changeset.put_assoc(:games, [game])
    |> Repo.update

    conn
    |> redirect(to: game_path(conn, :index))
  end
end
