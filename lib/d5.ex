defmodule D5 do
  @behaviour Solution

  use Bitwise

  def test_result, do: 820
  def test_result2, do: :no_test

  def solve(input) do
    input
    |> String.split()
    |> Stream.map(&parse_boarding_pass/1)
    |> Stream.map(&to_id/1)
    |> Enum.max()
  end

  def solve2(input) do
    ids =
      input
      |> String.split()
      |> Stream.map(&parse_boarding_pass/1)
      |> Stream.map(&to_id/1)
      |> Enum.to_list()

    {min, max} = Enum.min_max(ids)
    Enum.to_list(min..max) -- ids
  end

  defp parse_boarding_pass(<<row::binary-size(7), col::binary-size(3)>>) do
    {parse_bin(row), parse_bin(col)}
  end

  defp parse_bin(bin, acc \\ 0)
  defp parse_bin("F" <> rest, acc), do: parse_bin(rest, acc)
  defp parse_bin("B" <> rest, acc), do: parse_bin(rest, (1 <<< String.length(rest)) + acc)
  defp parse_bin("L" <> rest, acc), do: parse_bin(rest, acc)
  defp parse_bin("R" <> rest, acc), do: parse_bin(rest, (1 <<< String.length(rest)) + acc)
  defp parse_bin("", acc), do: acc

  defp to_id({row, col}), do: 8 * row + col
end
