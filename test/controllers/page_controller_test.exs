defmodule Pipeline.PageControllerTest do
  use Pipeline.ConnCase

  test "GET /" do
    conn = get conn(), "/"
    assert conn.resp_body =~ "Welcome to Phoenix!"
  end
end
