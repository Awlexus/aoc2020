defmodule D8 do
  @behaviour Solution

  @impl true
  def test_result, do: 5

  @impl true
  def test_result2, do: 8

  @impl true
  def test_input,
    do: """
    nop +0
    acc +1
    jmp +4
    acc +3
    jmp -3
    acc -99
    acc +1
    jmp -4
    acc +6
    """

  @impl true
  def test_input2, do: nil

  @impl true
  def solve(input) do
    %{acc: 0, cp: 0}
    |> execute_no_repeat(input)
    |> Map.get(:acc)
  end

  @impl true
  def solve2(input) do
    %{acc: 0, cp: 0}
    |> execute_no_repeat_find_faults(input, 1)
    |> Map.get(:acc)

    # Solve here
  end

  @impl true
  def parse_input(raw_input) do
    raw_input
    |> String.split("\n", trim: true)
    |> Stream.with_index()
    |> Map.new(fn {operation, index} ->
      {index, parse_operation(operation)}
    end)
  end

  defp parse_operation(operation) do
    [name, raw_value] = String.split(operation)
    {value, _} = Integer.parse(raw_value)

    {name, value}
  end

  defp execute_no_repeat(state, code) do
    cond do
      state.cp in Map.get(state, :run_instructions, []) ->
        state

      Map.has_key?(code, state.cp) ->
        {name, value} = code[state.cp]

        state
        |> execute_operation(name, value)
        |> execute_no_repeat(code)

      true ->
        state
    end
  end

  defp execute_no_repeat_find_faults(state, code, faults) do
    if state.cp in Map.get(state, :run_instructions, []) do
      false
    else
      case code[state.cp] do
        nil ->
          state

        {name, value} when name in ~w"nop jmp" ->
          state
          |> execute_operation(name, value)
          |> execute_no_repeat_find_faults(code, faults) ||
            (faults > 0 &&
               state
               |> execute_operation(switch_op(name), value)
               |> execute_no_repeat_find_faults(code, faults - 1))

        {name, value} ->
          state
          |> execute_operation(name, value)
          |> execute_no_repeat_find_faults(code, faults)
      end
    end
  end

  defp execute_operation(state, "acc", value),
    do: state |> Map.update!(:acc, &(&1 + value)) |> increment_cp()

  defp execute_operation(state, "jmp", value), do: increment_cp(state, value)
  defp execute_operation(state, "nop", _), do: increment_cp(state)

  defp increment_cp(state, amount \\ 1) do
    state
    |> Map.update(:run_instructions, [state.cp], &[state.cp | &1])
    |> Map.update!(:cp, &(&1 + amount))
  end

  defp switch_op("nop"), do: "jmp"
  defp switch_op("jmp"), do: "nop"
end
