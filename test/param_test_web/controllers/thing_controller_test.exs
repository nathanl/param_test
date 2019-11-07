defmodule ParamTestWeb.ThingControllerTest do
  use ParamTestWeb.ConnCase

  test "responds OK", %{conn: conn} do
    response = get(conn, "/api/things", %{count: 5})
    assert response.status == 200
  end
end
