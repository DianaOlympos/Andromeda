defmodule Evesurvey.GuardianSerializer do
  @behaviour Guardian.Serializer

  alias Evesurvey.Repo
  alias Evesurvey.User

#TODO : change the serialize for_token and from_token
  def for_token(user = %{id: _}), do: { :ok, "User:#{user.id}" }
  def for_token(_), do: { :error, "Unknown resource type" }

  def from_token("User:" <> id), do: { :ok, Repo.get(User, String.to_integer(id))}
  def from_token(_), do: { :error, "Unknown resource type" }
end
