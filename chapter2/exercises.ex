defmodule Exercises do
  @moduledoc """
  Exercises from The Little Elixir & OTP Guidebook, Section 2.9
  """
  def flatten([]), do: []

  def flatten([ head | tail ]) do
    flatten(head) ++ flatten(tail)
  end

  def flatten(head), do: [ head ]

  @doc """
  Exercise 1
  Implement sum/1. This function should take in a list of numbers and return the sum of the list.
  """
  def sum([]), do: 0

  def sum([head | tail]) do
    sum head + sum(tail)
  end

  def sum(head), do: head

  @doc """
  Exercise 3
  Trasnform [1, [[2], 3]] to [9, 4, 1] with and without the pipe operator
  """
  def transform(l) do
    Enum.map(
      Enum.reverse(flatten(l)),
      fn x -> x * x end
    )
  end

  @doc """
  Exercise 4
  Translate crypto:md5("Tales from the Crypt"). from Erlang to Elixir.
  """
  def md5_hash(s) do
    :crypto.hash(:md5, s)
  end
end
