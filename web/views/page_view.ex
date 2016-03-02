defmodule Andromeda.PageView do
  use Andromeda.Web, :view

  def is_authed?(conn) do
    Guardian.Plug.authenticated?(conn)
  end

end
