defmodule EveUser.User do
  alias EveUser.UserDetails
  @doc """
  Starts a new types container.
  """
  def start_link() do
    Agent.start_link(fn -> %UserDetails{} end)
  end

  @doc """
  Gets the user of price from the `user`.
  """
  def get_user(pid) when is_pid(pid) do
    Agent.get(pid, fn user -> user end)
  end

  def get_user(id) when is_integer(id) do
    with  pid <- EveUser.Registry.look_pid(EveUser.Registry,id),
          do: {:ok, Agent.get(pid, fn user -> user end)}
  end

  @doc """
  adds items to the list.
  """
  def update_user(pid, user) when is_pid(pid) do
    Agent.update(pid, fn _ -> user end)
  end

  def update_user(id, user) when is_integer(id) do
    with  {:ok, pid } <- EveUser.Registry.look_pid(EveUser.Registry,id),
        do: Agent.update(pid, fn _ -> user end)
  end

  def refresh_token(pid) do
    user = get_user(pid)
    params = Keyword.put([],:refresh_token, user.refresh_token)
    token = Andromeda.EveRefresh.get_token!(params)
    %{user | access_token: token.access_token}
    update_user(pid, user)
  end
end