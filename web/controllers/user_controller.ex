defmodule Gamedex.UserController do
  use Gamedex.Web, :controller

  alias Gamedex.Repo
  alias Gamedex.User
  alias Gamedex.Authorization

  def new(conn, params, current_user, _claims) do
    render conn, "new.html", current_user: current_user
  end
end
