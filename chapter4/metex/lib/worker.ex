defmodule Metex.Worker do
  use GenServer

  @name MW

  ## Client API

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts ++ [name: MW])
  end

  def get_temperature(location) do
    GenServer.call(@name, {:location, location})
  end

  def get_stats() do
    GenServer.call(@name, :get_stats)
  end

  def reset_stats() do
    GenServer.cast(@name, :reset_stats)
  end

  def stop() do
    GenServer.cast(@name, :stop)
  end

  ## Server Callbacks

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:location, location}, __from, stats) do
    case temperature_of(location) do
      {:ok, temp} ->
        new_stats = update_stats(stats, location)
        {:reply, "#{temp}°C", new_stats}
      _ ->
        {:reply, :error, stats}
    end
  end

  def handle_call(:get_stats, __from, stats) do
    {:reply, stats, stats}
  end

  def handle_cast(:reset_stats, _stats) do
    {:noreply, %{}}
  end

  def handle_cast(:stop, stats) do
    {:stop, :normal, stats}
  end

  def terminate(reason, stats) do
    # We could write to a file, database etc
    IO.puts "server terminated because of #{inspect reason}"
    inspect(stats)
    :ok
  end

  def handle_info(msg, stats) do
    IO.puts("received #{msg}")
    {:noreply, stats}
  end

  ## Helper Functions

  defp temperature_of(location) do
    url_for(location) |> HTTPoison.get |> parse_response()
  end

  defp url_for(location) do
    "http://api.openweathermap.org/data/2.5/weather?q=#{location}&appid=#{apikey()}"
  end

  defp parse_response({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    body |> JSON.decode! |> compute_temperature
  end

  defp parse_response(_), do: :error

  defp compute_temperature(json) do
    try do
      temp = (json["main"]["temp"] - 273.15) |> Float.round(1)
      {:ok, temp}
    rescue
      _ -> :error
    end
  end

  defp apikey do
    "74148f1e51e4ac1feba5e0d04c2a1ec2"
  end

  defp update_stats(old_stats, location) do
    case Map.has_key?(old_stats, location) do
      true ->
        Map.update!(old_stats, location, &(&1 + 1))
      false ->
        Map.put_new(old_stats, location, 1)
    end
  end
end


# {:ok, pid} = Metex.Worker.start_link
# Metex.Worker.get_temperature(pid, "Rome")
# Metex.Worker.get_temperature(pid, "Birmingham, UK")
# Metex.Worker.get_temperature(pid, "London")
# Metex.Worker.get_temperature(pid, "Toronto")
# Metex.Worker.get_temperature(pid, "London")
# Metex.Worker.get_temperature(pid, "London")
# Metex.Worker.get_temperature(pid, "Birmingham, UK")
# Metex.Worker.get_stats(pid)
# Metex.Worker.reset_stats(pid)
# Metex.Worker.get_stats(pid)
