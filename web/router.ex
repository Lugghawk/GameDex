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

  scope "/", Gamedex do
    pipe_through [:browser, :browser_auth] # Use the default browser stack

    get "/", PageController, :index
    delete "/", AuthController, :logout

    resources "/users", UserController
    resources "/authorizations", AuthorizationController
    resources "/tokens", TokenController

    get "/private", PrivatePageController, :index
  end

  scope "/auth", Gamedex do
    pipe_through [:browser, :browser_auth]

    get "/:identity", AuthController, :login
    get "/:identity/callback", AuthController, :callback
    post "/:identity/callback", AuthController, :callback
  end



  # Other scopes may use custom stacks.
  scope "/api", Gamedex do
    pipe_through [:api, :api_auth]
  end
end
