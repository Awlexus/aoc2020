defmodule D3 do
  @behaviour Solution

  def test_result, do: 7
  def test_result2, do: 336

  def solve(input) do
    [first | _] = map = simplify_map(input)

    traverse_map(map, length(first), 3, 1)
  end

  def solve2(input) do
    [first | _] = map = simplify_map(input)

    width = length(first)

    [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]
    |> Stream.map(fn {right, down} -> traverse_map(map, width, right, down) end)
    |> Enum.reduce(&Kernel.*/2)
  end

  defp simplify_map(input) do
    input
    |> String.split("\n", trim: true)
    |> Stream.map(&String.to_charlist/1)
    |> Enum.map(fn line ->
      Enum.map(line, fn
        ?. -> 0
        ?# -> 1
      end)
    end)
  end

  defp traverse_map(map, width, right, down) do
    map
    |> Stream.take_every(down)
    |> Stream.drop(1)
    |> Stream.with_index(1)
    |> Stream.map(fn {line, index} -> Enum.at(line, rem(right * index, width)) end)
    |> Enum.sum()
  end
end
