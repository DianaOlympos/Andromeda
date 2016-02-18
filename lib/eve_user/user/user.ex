defmodule EveUser.User do
  @doc """
  Starts a new types container.
  """
  def start_link(user = %UserDetails{}) do
    Agent.start_link(fn -> user end)
  end

  @doc """
  Gets the list of price from the `types`.
  """
  def get_user(pid) do
    Agent.get(pid, fn user -> user end)
  end

  @doc """
  adds items to the list.
  """
  def update_user(pid,user) do
    Agent.update(pid, fn -> user end)
  end

end