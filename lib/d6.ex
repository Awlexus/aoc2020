defmodule D6 do
  @behaviour Solution

  @impl true
  def test_result, do: 11
  @impl true
  def test_result2, do: 6

  @impl true
  def parse_input(raw_input) do
    raw_input
    |> String.split("\n\n")
    |> Stream.map(&parse_group/1)
  end

  @impl true
  def solve(input) do
    input
    |> Stream.flat_map(fn {_, map} -> Map.keys(map) end)
    |> Enum.count()
  end

  @impl true
  def solve2(input) do
    input
    |> Stream.flat_map(fn {count, map} -> Enum.filter(map, fn {_, yes} -> yes == count end) end)
    |> Enum.count()
  end

  defp parse_group(string) do
    count = string |> String.split() |> Enum.count()

    group =
      string
      |> String.to_charlist()
      |> Enum.frequencies()
      |> Enum.filter(fn {k, _} -> k in ?a..?z end)
      |> Map.new()

    {count, group}
  end
end
