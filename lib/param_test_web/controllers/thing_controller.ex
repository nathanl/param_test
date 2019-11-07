defmodule ParamTestWeb.ThingController do
  use ParamTestWeb, :controller

  def index(conn, %{"count" => n}) when is_integer(n) do
    json(conn, %{})
  end

  def index(conn, params) do
    raise ArgumentError, inspect(["invalid params", params])
  end
end
