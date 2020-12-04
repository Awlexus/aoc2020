defmodule D4 do
  @behaviour Solution

  def test_result, do: 2
  def test_result2, do: 2

  @keys ~w"byr iyr eyr hgt hcl ecl pid"
  @eye_colors ~w"amb blu brn gry grn hzl oth"

  def solve(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Stream.map(&parse_passport/1)
    |> Enum.count(&passport_valid?/1)
  end

  def solve2(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Stream.map(&parse_passport/1)
    |> Enum.count(&passport_valid2?/1)
  end

  defp parse_passport(line) do
    line
    |> String.split()
    |> Map.new(&parse_value/1)
  end

  defp parse_value(<<key::binary-size(3), ?:, value::binary>>), do: {key, value}

  defp passport_valid?(passport) do
    keys = Map.keys(passport)

    Enum.all?(@keys, &(&1 in keys))
  end

  defp passport_valid2?(passport) do
    with true <- passport_valid?(passport) do
      Enum.reduce_while(passport, true, fn {k, v}, _ ->

        if validate_field(k, v) do
          {:cont, true}
        else
          {:halt, false}
        end
      end)
    end
  end

  defp validate_field("byr", value), do: validate_num(value, 1920, 2002)
  defp validate_field("iyr", value), do: validate_num(value, 2010, 2020)
  defp validate_field("eyr", value), do: validate_num(value, 2020, 2030)
  defp validate_field("hgt", value),
    do: validate_num(value, 150, 193, "cm") or validate_num(value, 59, 76, "in")
  defp validate_field("hcl", value), do: value =~ ~r/^#[0-9a-f]{6}$/
  defp validate_field("ecl", value), do: value in @eye_colors
  defp validate_field("pid", value), do: value =~ ~r/^[0-9]{9}$/
  defp validate_field("cid", _value), do: true

  defp validate_num(str, min, max, rest \\ "") do
    case Integer.parse(str) do
      {num, ^rest} when num in min..max -> true
      _ -> false
    end
  end
end
