defmodule Exercise.Worker do
  use GenServer

  @name EW

  ## Client API

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts ++ [name: EW])
  end

  def write(key, value) do
    GenServer.call(@name, %{write: %{key: key, value: value}})
  end

  def delete(key) do
    GenServer.call(@name, %{delete: key})
  end


  def get_cache do
    GenServer.call(@name, :get_cache)
  end

  def exist?(key) do
    GenServer.call(@name, %{exist: key})
  end

  def clear() do
    GenServer.cast(@name, :clear)
  end

  def stop() do
    GenServer.cast(@name, :stop)
  end

  ## Server Callbacks

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call(%{write: %{key: key, value: value}}, __from, state) do
    new_state = add_to_cache(state, %{key: key, value: value})
    {:reply, :ok, new_state}
  end

  def handle_call(%{delete: key}, __from, state) do
    new_state = delete_from_cache(state, key)
    {:reply, :ok, new_state}
  end

  def handle_call(%{exist: key}, __from, state) do
    {:reply, has_key?(state, key), state}
  end

  def handle_call(:get_cache, __from, state) do
    {:reply, state, state}
  end

  def handle_cast(:clear, __state) do
    {:noreply, %{}}
  end

  def handle_cast(:stop, state) do
    {:stop, :normal, state}
  end

  ## Helper Functions

  def add_to_cache(state, %{key: key, value: value}) do
    case has_key?(state, key) do
      true -> Map.update!(state, key, value)
      false -> Map.put(state, key, value)
    end
  end

  def delete_from_cache(state, key) do
    case has_key?(state, key) do
      true -> Map.delete(state, key)
      false -> state
    end
  end

  def has_key?(state, key) do
    Map.has_key?(state, key)
  end

end

# {:ok, pid} = Exercise.Worker.start_link
# Exercise.Worker.write(:cities, ["Rome", "London"])
# Exercise.Worker.get_cache()
# Exercise.Worker.write(:stooges, ["Larry", "Curly", "Moe"])
# Exercise.Worker.delete(:stooges)
# Exercise.Worker.exist?(:stooges)
