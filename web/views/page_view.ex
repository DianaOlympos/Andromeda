defmodule Andromeda.PageView do
  use Andromeda.Web, :view
  alias EveUser.UserDetails
  
  def is_authed?({:error, _msg}), do: false
  def is_authed?(user=%UserDetails{}), do: true
end
