defmodule Andromeda.PageController do
  use Andromeda.Web, :controller
  alias Guardian.Plug.EnsurePermissions

  def index(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    render conn, "index.html", user: user
  end
end
