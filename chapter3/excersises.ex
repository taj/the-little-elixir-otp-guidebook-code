defmodule Exercise do
  def run() do
    pboss = spawn(ProcessBoss, :loop, [])
    pid1 = spawn(Process1, :loop, [])
    pid2 = spawn(Process2, :loop, [])

    send pid1, {pboss, :ping}
    send pid2, {pboss, :pong}
  end
end

defmodule ProcessBoss do
  def loop do
    receive do
      {:ok, msg, from: from} -> IO.inspect("#{from} says #{msg}")
      _ -> IO.puts "Unknow Message"
    end
    loop()
  end
end

defmodule Process1 do
  def loop do
    receive do
      {sender_pid, :ping} ->
        send(sender_pid, {:ok, :pong, from: :ping})
      _ ->
        IO.puts "Unknow Message"
    end
    loop()
  end
end

defmodule Process2 do
  def loop do
    receive do
      {sender_pid, :pong} ->
        send(sender_pid, {:ok, :ping, from: :pong})
      _ -> IO.puts "Unknow Message"
    end
    loop()
  end
end
