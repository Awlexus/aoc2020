defmodule Solution do
  @type result :: any()
  @type input :: String.t()
  @type test_result :: any()

  @callback solve(input()) :: result()
  @callback solve2(input()) :: result()

  @callback test_result() :: test_result()
  @callback test_result2() :: test_result()

  def try1(module) do
    do_try("one", module, &module.solve/1, module.test_result())
  end

  def try2(module) do
    do_try("two", module, &module.solve2/1, module.test_result2())
  end

  defp do_try(part, module, solver, test_result) do
    test_input = test_input(module)

    IO.puts("""
    #{IO.ANSI.yellow()}Running part #{part}...#{IO.ANSI.reset()}
    Test input:

    #{test_input}
    """)

    case solver.(test_input) do
      ^test_result ->
        real_input = real_input(module)

        IO.puts("""
        #{IO.ANSI.green()}Test was successful.#{IO.ANSI.reset()}
        Solution: #{inspect(solver.(real_input))}
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
