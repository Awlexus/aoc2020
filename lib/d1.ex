defmodule D1 do
  @behaviour Solution
  @target 2020

  def test_result, do: 514_579
  def test_result2, do: 241_861_950

  def solve(input) do
    result =
      input
      |> String.split("\n", trim: true)
      |> Stream.map(&String.trim_trailing/1)
      |> Enum.map(&String.to_integer/1)
      |> find_pair()

    with {a, b} <- result, do: a * b
  end

  def solve2(input) do
    result =
      input
      |> String.split("\n", trim: true)
      |> Stream.map(&String.trim_trailing/1)
      |> Enum.map(&String.to_integer/1)
      |> find_triplet()

    with {a, b, c} <- result, do: a * b * c
  end

  # Helpers

  def find_pair([]), do: nil

  def find_pair([h | t]) do
    if result = find_pair(h, t) do
      result
    else
      find_pair(t)
    end
  end

  defp find_pair(a, [b | _]) when a + b == @target, do: {a, b}
  defp find_pair(a, [_ | t]), do: find_pair(a, t)
  defp find_pair(_, []), do: false

  def find_triplet([_, _]), do: false

  def find_triplet([h | t]) do
    if result = find_triplet(h, t) do
      result
    else
      find_triplet(t)
    end
  end

  def find_triplet(a, [b | t]) when a + b < @target, do: find_triplet(a, b, t)
  def find_triplet(a, [_ | t]), do: find_triplet(a, t)
  def find_triplet(_, []), do: false

  def find_triplet(a, b, [c | _]) when a + b + c == @target, do: {a, b, c}
  def find_triplet(a, b, [_ | t]), do: find_triplet(a, b, t)
  def find_triplet(_, _, []), do: false
end
