defmodule Exercise do
  @moduledoc """
  Exercises from The Little Elixir & OTP Guidebook, Section 4.4.

  Write a `GenServer` taht can store any valid Elixir term, given a key. Here are a few operations to get you started:

  - `Cache.write(:stooges, ["Larry", "Curly", "Moe"])`
  - `Cache.read(:stooges)`
  - `Cache.delete(:stooges)`
  - `Cache.clear(:stooges)`
  - `Cache.exist(:stooges)`
  """

  @doc """
  Hello world.

  ## Examples

      iex> Exercise.hello()
      :world

  """
  def hello do
    :world
  end
end
