defmodule D9 do
  @behaviour Solution

  @impl true
  def test_result, do: 127
  @impl true
  def test_result2, do: 62
  @impl true
  def test_input do
    """
    5
    35
    20
    15
    25
    47
    40
    62
    55
    65
    95
    102
    117
    150
    182
    127
    219
    299
    277
    309
    576
    """
  end

  @impl true
  def test_input2, do: nil

  @impl true
  def solve({preamble, numbers}) do
    find_odd_number(numbers, preamble)
  end

  @impl true
  def solve2({preamble, numbers}) do
    number = find_odd_number(numbers, preamble)

    {min, max} =
      numbers
      |> find_cont_set(number)
      |> Enum.min_max()

    min + max
  end

  @impl true
  def parse_input(raw_input) do
    [preamble | numbers] =
      raw_input
      |> String.split()
      |> Enum.map(&String.to_integer/1)

    {preamble, numbers}
  end

  defp find_odd_number(numbers, preamble) do
    [number | preambles] =
      numbers
      |> Enum.take(preamble + 1)
      |> Enum.reverse()

    if any_sum_of?(number, preambles) do
      find_odd_number(tl(numbers), preamble)
    else
      number
    end
  end

  defp any_sum_of?(number, [a, b | _]) when a + b == number, do: true

  defp any_sum_of?(number, [a, b | t]) do
    any_sum_of?(number, [a | t]) || any_sum_of?(number, [b | t])
  end

  defp any_sum_of?(_, _), do: false

  defp find_cont_set(list, number) do
    Enum.reduce_while(list, {0, []}, fn
      a, {acc, list} when a + acc == number -> {:halt, [a | list]}
      a, {acc, list} when a + acc < number -> {:cont, {a + acc, [a | list]}}
      _, _ -> {:halt, false}
    end) || find_cont_set(tl(list), number)
  end
end
