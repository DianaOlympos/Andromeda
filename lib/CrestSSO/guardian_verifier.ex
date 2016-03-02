defmodule Andromeda.GuardianVerifier do

  def validate_claim("sub", payload, _opts) do
    sub = Map.get(payload, "sub")
    case Guardian.serializer.from_token(sub) do
      {:ok, _} -> :ok
      error -> error
    end
  end

  use Guardian.ClaimValidation

  def validate_claim(_, _, _), do: :ok
end