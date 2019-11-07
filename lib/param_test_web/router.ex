defmodule ParamTestWeb.Router do
  use ParamTestWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ParamTestWeb do
    pipe_through :api
    get("/things", ThingController, :index)
  end
end
