defmodule Metex.Worker do
  def loop do
    receive do
      {sender_pid, location} ->
        send(sender_pid, {:ok, temperature_of(location)})
      _ ->
        IO.puts "don't know how to process this message"
    end
    loop()
  end

  def temperature_of(location) do
    result = url_for(location) |> HTTPoison.get |> parse_response
    case result do
      {:ok, temp} ->
        "#{location}: #{temp}°C"
      :error ->
        "#{location}: not found"
    end
  end

  defp url_for(location) do
    location = URI.encode(location)
    "http://api.openweathermap.org/data/2.5/weather?q=#{location}&appid=#{apikey()}"
  end

  defp parse_response({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    body |> JSON.decode! |> compute_temperature
  end

  defp parse_response(_) do
    :error
  end

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
end

# cities = ["Singapore", "Monaco", "Vatican City", "Hong Kong", "Macau"]

# Without Processes
# cities |> Enum.map(fn city -> Metex.Worker.temperature_of(city) end)

# With Processes
# pid = spawn(Metex.Worker, :loop, [])
# cities |> Enum.each(fn city ->
#   pid = spawn(Metex.Worker, :loop, [])
#   send(pid, {self, city})
# end)
