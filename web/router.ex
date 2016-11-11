defmodule Gamedex.Router do
  use Gamedex.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :browser_auth do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  pipeline :admin_browser_auth do
    plug Guardian.Plug.VerifySession, key: :admin
    plug Guardian.Plug.LoadResource, key: :admin
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_auth do
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  pipeline :impersonation_browser_auth do
    plug Guardian.Plug.VerifySession, key: :admin
  end

  scope "/", Gamedex do
    pipe_through [:browser, :browser_auth] # Use the default browser stack

    get "/", PageController, :index
    delete "/logout", AuthController, :logout

    post "/users/:id", UserController, :add_game
    resources "/users", UserController
    resources "/games", GameController
    resources "/authorizations", AuthorizationController
    resources "/tokens", TokenController

    get "/private", PrivatePageController, :index
  end

  scope "/auth", Gamedex do
    pipe_through [:browser, :browser_auth, :impersonation_browser_auth]

    get "/:identity", AuthController, :login
    get "/:identity/callback", AuthController, :callback
    post "/:identity/callback", AuthController, :callback
  end

  # This scope is intended for admin users.
  # Normal users can only go to the login page
  scope "/admin", Gamedex.Admin, as: :admin do
    pipe_through [:browser, :admin_browser_auth] # Use the default browser stack

    get "/login", SessionController, :new, as: :login
    get "/login/:identity", SessionController, :new
    get "/auth/:identity", SessionController, :new, as: :login
    get "/auth/:identity/callback", SessionController, :callback
    post "/auth/:identity/callback", SessionController, :callback
    get "/logout", SessionController, :logout
    delete "/logout", SessionController, :logout, as: :logout
    post "/impersonate/:user_id", SessionController, :impersonate, as: :impersonation
    delete "/impersonate", SessionController, :stop_impersonating

    resources "/users", UserController
  end



  # Other scopes may use custom stacks.
  scope "/api", Gamedex do
    pipe_through [:api, :api_auth]
  end
end
