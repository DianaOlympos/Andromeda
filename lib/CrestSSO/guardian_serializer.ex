defmodule Andromeda.GuardianSerializer do
  @behaviour Guardian.Serializer
  alias EveUser.UserDetails

#TODO : change the serialize for_token and from_token
  def for_token(user = %UserDetails{}), do: { :ok, "User:#{user.id}" }
  def for_token(_), do: { :error, "Unknown resource type" }

  def from_token("User:" <> id), do: { :ok, EveUser.User.get_user(id)}
  def from_token(_), do: { :error, "Unknown resource type" }
end
