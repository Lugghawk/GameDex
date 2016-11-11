defmodule Gamedex.GameController do
  use Gamedex.Web, :controller

  alias Gamedex.Game

  plug EnsureAuthenticated, handler: __MODULE__, typ: "access"

  def index(conn, _params, current_user, _claims) do
    %{games: games} = Repo.preload(current_user, :games)
    addable_games = ["Foo": "foo"]
    render(conn, "index.html", games: games, current_user: current_user, addable_games: addable_games)
  end

  def new(conn, _params, current_user, _claims) do
    changeset = Game.changeset(%Game{})
    render(conn, "new.html", changeset: changeset, current_user: current_user)
  end

  def create(conn, %{"game" => game_params}, current_user, _claims) do
    changeset = Game.changeset(%Game{}, game_params)

    case Repo.insert(changeset) do
      {:ok, _game} ->
        conn
        |> put_flash(:info, "Game created successfully.")
        |> redirect(to: game_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, current_user: current_user)
    end
  end

  def show(conn, %{"id" => id}, current_user, _claims) do
    game = Repo.get!(Game, id)
    render(conn, "show.html", game: game, current_user: current_user)
  end

  def edit(conn, %{"id" => id}, current_user, _claims) do
    game = Repo.get!(Game, id)
    changeset = Game.changeset(game)
    render(conn, "edit.html", game: game, changeset: changeset, current_user: current_user)
  end

  def update(conn, %{"id" => id, "game" => game_params}, current_user, _claims) do
    game = Repo.get!(Game, id)
    changeset = Game.changeset(game, game_params)

    case Repo.update(changeset) do
      {:ok, game} ->
        conn
        |> put_flash(:info, "Game updated successfully.")
        |> redirect(to: game_path(conn, :show, game))
      {:error, changeset} ->
        render(conn, "edit.html", game: game, changeset: changeset, current_user: current_user)
    end
  end

  def delete(conn, %{"id" => id}, current_user, _claims) do
    game = Repo.get!(Game, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(game)

    conn
    |> put_flash(:info, "Game deleted successfully.")
    |> redirect(to: game_path(conn, :index))
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_flash(:error, "Not authenticated.")
    |> redirect(to: auth_path(conn, :login, "identity"))
  end
end
