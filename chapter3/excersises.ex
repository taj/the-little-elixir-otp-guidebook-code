defmodule Exercise do
  @moduledoc """
  Exercises from The Little Elixir & OTP Guidebook, Section 3.6

  Write a program that spawns two processes. The first process, on receiving a `ping` messag, should reply with a `pong` message. The second process, on receiving a `pong` message, should reply with a `ping` message.
  """

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
