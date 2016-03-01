defmodule Andromeda.PageView do
  use Andromeda.Web, :view

  def is_authed?(user), do: true
  def is_authed?({:error, _msg}), do: false
end
