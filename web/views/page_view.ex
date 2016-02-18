defmodule Andromeda.PageView do
  use Andromeda.Web, :view

  def is_authed?(user) do
    user != nil
  end

end
