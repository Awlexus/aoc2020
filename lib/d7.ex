defmodule D7 do
  @behaviour Solution

  @impl true
  def test_result, do: 4
  @impl true
  def test_input,
    do: """
      light red bags contain 1 bright white bag, 2 muted yellow bags.
      dark orange bags contain 3 bright white bags, 4 muted yellow bags.
      bright white bags contain 1 shiny gold bag.
      muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
      shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
      dark olive bags contain 3 faded blue bags, 4 dotted black bags.
      vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
      faded blue bags contain no other bags.
      dotted black bags contain no other bags.
    """

  @impl true
  def test_result2, do: 126

  @impl true
  def test_input2,
    do: """
    shiny gold bags contain 2 dark red bags.
    dark red bags contain 2 dark orange bags.
    dark orange bags contain 2 dark yellow bags.
    dark yellow bags contain 2 dark green bags.
    dark green bags contain 2 dark blue bags.
    dark blue bags contain 2 dark violet bags.
    dark violet bags contain no other bags.
    """

  @impl true
  def solve(input) do
    input
    |> Map.keys()
    |> Enum.map(&can_contain?(&1, input, "shiny gold"))
    |> Enum.count(& &1)
  end

  @impl true
  def solve2(input) do
    must_contain("shiny gold", input) - 1
  end

  defp can_contain?(bag, bags, target_bag) do
    if Map.has_key?(bags[bag], target_bag) do
      true
    else
      bags[bag]
      |> Map.keys()
      |> Enum.any?(&can_contain?(&1, bags, target_bag))
    end
  end

  @impl true
  def parse_input(raw_input) do
    raw_input
    |> String.split("\n", trim: true)
    |> Map.new(&parse_rule/1)
  end

  defp parse_rule(rule) do
    [bag, others] = String.split(rule, " contain ")

    others =
      others
      |> String.split(", ")
      |> Stream.map(&Integer.parse/1)
      |> Stream.reject(&(&1 == :error))
      |> Map.new(fn {int, other} -> {normalize_bag(other), int} end)

    {normalize_bag(bag), others}
  end

  defp normalize_bag(bag) do
    bag
    |> String.replace(~r"bags?\.?", "")
    |> String.trim()
  end

  defp must_contain(bag, bags) do
    bags[bag]
    |> Enum.map(fn {bag, amount} -> must_contain(bag, bags) * amount end)
    |> Enum.sum()
    |> Kernel.+(1)
  end
end
