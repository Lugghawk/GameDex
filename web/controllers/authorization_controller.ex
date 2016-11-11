defmodule Gamedex.AuthorizationController do
  use Gamedex.Web, :controller
  use Guardian.Phoenix.Controller

  alias Gamedex.Repo
  alias Gamedex.Authorization

  def index(conn, params, current_user, _claims) do
    auths = authorizations(current_user)
    IO.inspect auths
    render conn, "index.html", current_user: current_user, authorizations: authorizations(current_user)
  end

  defp authorizations(user) do
    Ecto.assoc(user, :authorizations) |> Repo.all
  end
end
