defmodule D2 do
  @behaviour Solution
  @regex ~r/(\d+)-(\d+) (.): (.+)/

  def test_result, do: 2
  def test_result2, do: 1

  def solve(input) do
    input
    |> String.split("\n", trim: true)
    |> Stream.map(&parse_line/1)
    |> Stream.filter(&valid_policy?/1)
    |> Enum.count()
  end

  def solve2(input) do
    input
    |> String.split("\n", trim: true)
    |> Stream.map(&parse_line/1)
    |> Stream.filter(&valid_policy2?/1)
    |> Enum.count()
  end

  ## Helpers

  defp parse_line(line) do
    [min, max, <<letter>>, password] = Regex.run(@regex, line, capture: :all_but_first)

    %{
      min: String.to_integer(min),
      max: String.to_integer(max),
      letter: letter,
      password: String.to_charlist(password)
    }
  end

  defp valid_policy?(policy) do
    Enum.count(policy.password, &(&1 == policy.letter)) in policy.min..policy.max
  end

  defp valid_policy2?(policy) do
    letter = policy.letter
    first = Enum.at(policy.password, policy.min - 1)
    second = Enum.at(policy.password, policy.max - 1)

    case {first, second} do
      {a, a} -> false
      {a, b} when a == letter or b == letter -> true
      _ -> false
    end
  end
end
