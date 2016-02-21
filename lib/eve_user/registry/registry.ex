defmodule EveUser.Registry do
  use GenServer
  alias EveUser.UserDetails

  ## Client API

  @doc """
  Starts the registry with the given `name`.
  """
  def start_link(name) do
    GenServer.start_link(__MODULE__, name, name: name)
  end

  @doc """
  Looks up the type pid for `id` stored in `server`.

  Returns `{:ok, pid}` if the user exists, `:error` otherwise.
  """
  defp lookup(server, id) when is_atom(server) do
    case :ets.lookup(server, id) do
      [{^id, pid}] -> {:ok, pid}
      [] -> {:error, "no id"}
    end
  end

  @doc """
  Ensures there is a user associated to the given `id` in `server`.
  """
  def create(server, user= %UserDetails{}) do
    GenServer.call(server, {:create, user})
  end

  @doc """
  Look for the pid for the corresponding id
  """
  def look_pid(server, id) do
    GenServer.call(server, {:look, id})
  end

  @doc """
  Stops the registry.
  """
  def stop(server) do
    GenServer.stop(server)
  end

  ## Server callbacks

  def init(table) do
    types = :ets.new(table, [:named_table, read_concurrency: true])
    refs  = %{}
    {:ok, {types, refs}}
  end

  def handle_call({:create, user = %UserDetails{}}, _from, {users, refs}) do
    case lookup(users, user.id) do
      {:ok, pid} ->
        {:reply, pid, {users, refs}}
      {:error, _} ->
        {:ok, pid} = EveUser.User.Supervisor.start_types(user)
        ref = Process.monitor(pid)
        refs = Map.put(refs, ref, user.id)
        :ets.insert(users, {user.id, pid})
        {:reply, pid, {users, refs}}
    end
  end

  def handle_call({:look, id}, _from, {users, refs}) do
    case lookup(users, id) do
      {:ok, pid} ->
        {:reply, pid, {users, refs}}
      {:error, msg } ->
        {:reply, {:error, msg}, {users, refs}}
    end
  end

  def handle_info({:DOWN, ref, :process, _pid, _reason}, {users, refs}) do
    {id, refs} = Map.pop(refs, ref)
    :ets.delete(users, id)
    {:noreply, {users, refs}}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end
end