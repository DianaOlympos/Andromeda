defmodule Andromeda.PageView do
  use Andromeda.Web, :view

  def is_authed?(id) do
    case EveUser.UserDetails.get_user(id) do
      user -> true
      {:error, _msg) -> false
    end
  end

end
