defmodule EveUser.User do
  @doc """
  Starts a new types container.
  """
  def start_link(user = %UserDetails{}) do
    Agent.start_link(fn -> user end)
  end

  @doc """
  Gets the user of price from the `user`.
  """
  def get_user(pid) when is_pid(pid) do
    Agent.get(pid, fn user -> user end)
  end

  def get_user(id) when is_integer(id) do
    with  {:ok, pid } <-  EveUser.Registry.look_pid(EveUser.Registry,id)
          user        <-  Agent.get(pid, fn user -> user end)
          do: user
  end

  @doc """
  adds items to the list.
  """
  def update_user(pid,user) do
    Agent.update(pid, fn -> user end)
  end

end