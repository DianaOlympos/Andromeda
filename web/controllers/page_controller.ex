defmodule Andromeda.PageController do
  use Andromeda.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
