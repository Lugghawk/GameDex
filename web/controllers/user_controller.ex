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
    game = Repo.get(Game, game_added)
    current_user = Repo.preload(current_user, :games)
    games = Enum.map([game | current_user.games], &Ecto.Changeset.change/1)
    changeset = Ecto.Changeset.change(current_user)
    |> Ecto.Changeset.put_assoc(:games, games)
    |> Repo.update!

    conn
    |> redirect(to: game_path(conn, :index))
  end
end
