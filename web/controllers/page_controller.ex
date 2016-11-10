defmodule Gamedex.PageController do
  use Gamedex.Web, :controller
  alias GameDex.Repo

  def index(conn, _params, current_user, _claims) do
    render conn, "index.html", current_user: current_user
  end
end
