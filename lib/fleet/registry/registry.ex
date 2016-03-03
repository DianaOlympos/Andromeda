defmodule EveFleet.Registry do
  use GenServer
  alias EveFleet.FleetDetails

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
  def lookup(server, id) when is_atom(server) do
    case :ets.lookup(server, id) do
      [{^id, pid}] -> {:ok, pid}
      [] -> {:error, "no id"}
    end
  end

  @doc """
  Ensures there is a user associated to the given `id` in `server`.
  """
  def create(server, fleet \\%FleetDetails{}) do
    GenServer.call(server, {:create, fleet})
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
    fleets = :ets.new(table, [:named_table, read_concurrency: true])
    refs  = %{}
    {:ok, {fleets, refs}}
  end

  def handle_call({:create, fleet}, _from, {fleets, refs}) do
    case lookup(fleets, fleet.id) do
      {:ok, pid} ->
        {:reply, pid, {fleets, refs}}
      {:error, _} ->
        {:ok, pid} = EveFleet.Fleet.Supervisor.start_fleets()
        EveFleet.Fleet.update(pid, fleet)
        ref = Process.monitor(pid)
        refs = Map.put(refs, ref, fleet.id)
        :ets.insert(fleets, {fleet.id, pid})
        {:reply, pid, {fleets, refs}}
    end
  end

  def handle_call({:look, id}, _from, {fleets, refs}) do
    case lookup(fleets, id) do
      {:ok, pid} ->
        {:reply, {:ok, pid}, {fleets, refs}}
      {:error, msg } ->
        {:reply, {:error, msg}, {fleets, refs}}
    end
  end

  def handle_info({:DOWN, ref, :process, _pid, _reason}, {fleets, refs}) do
    {id, refs} = Map.pop(refs, ref)
    :ets.delete(fleets, id)
    {:noreply, {fleets, refs}}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end
end