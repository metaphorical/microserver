defmodule ElixirMicroserverWeb.Router do
  use ElixirMicroserverWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ElixirMicroserverWeb do
    pipe_through :api
  end
end
