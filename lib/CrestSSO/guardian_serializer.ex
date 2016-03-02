defmodule Andromeda.GuardianSerializer do
  @behaviour Guardian.Serializer


  def for_token(id) when is_integer(id), do: { :ok, "User:#{id}" }
  def for_token(_), do: { :error, "Unknown resource type" }

  def from_token("User:" <> id), do: handler_user(id)
  def from_token(_), do: { :error, "Unknown resource type" }

  defp handler_user(id) do
    EveUser.User.get_user(String.to_integer(id))
  end
end
