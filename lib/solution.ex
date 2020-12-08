defmodule Solution do
  @type result :: any()
  @type input :: any()
  @type test_result :: any()

  @callback solve(input()) :: result()
  @callback solve2(input()) :: result()

  @callback test_result() :: test_result()
  @callback test_result2() :: test_result()

  @callback test_input() :: input()
  @callback test_input2() :: input() | nil

  @callback parse_input(String.t()) :: input()

  def try1(module) do
    do_try("one", module, &module.solve/1, module.test_result(), module.test_input())
  end

  def try2(module) do
    do_try("two", module, &module.solve2/1, module.test_result2(), module.test_input2() || module.test_input())
  end

  defp do_try(part, module, solver, :no_test, _) do
    solution =
      module
      |> real_input()
      |> module.parse_input()
      |> solver.()

    IO.puts("""
    #{IO.ANSI.yellow()}Running part #{part}...#{IO.ANSI.reset()}
    Skipping test...
    Solution: #{inspect(solution)}
    """)
  end

  defp do_try(part, module, solver, test_result, test_input) do
    test_input = test_input || test_input(module)

    IO.puts("""
    #{IO.ANSI.yellow()}Running part #{part}...#{IO.ANSI.reset()}
    Test input:

    #{test_input}
    """)

    case solver.(module.parse_input(test_input)) do
      ^test_result ->
        solution =
          module
          |> real_input()
          |> module.parse_input()
          |> solver.()

        IO.puts("""
        #{IO.ANSI.green()}Test was successful.#{IO.ANSI.reset()}
        Solution: #{inspect(solution)}
        """)

      other ->
        IO.puts("""
        Test failed...

        Expected: #{IO.ANSI.green()}#{inspect(test_result)}#{IO.ANSI.reset()}
        Got:      #{IO.ANSI.red()}#{inspect(other)}#{IO.ANSI.reset()}
        """)
    end
  end

  defp input_filename(module) do
    module
    |> Module.split()
    |> Enum.join(".")
    |> String.downcase()
    |> Kernel.<>(".txt")
  end

  defp real_input(module), do: Path.join("input", input_filename(module)) |> File.read!()
  defp test_input(module), do: Path.join("test_input", input_filename(module)) |> File.read!()
end
