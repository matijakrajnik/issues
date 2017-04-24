defmodule ControlFlow do
  def upto(n) when n > 0 do
    1..n |> Enum.map(&_fizzbuzz(&1))
  end

  defp _fizzbuzz(n) do
    case { rem(n, 3), rem(n, 5), n } do
      { 0, 0, _ } -> "FizzBuzz"
      { 0, _, _ } -> "Fizz"
      { _, 0, _ } -> "Buzz"
      { _, _, n } -> n
    end
  end

  def ok!(value) do
    case { value } do
	  { {:ok, data} }  -> data
	  { {_, message} } -> raise "Exception: #{message}"
	  _                -> raise "Unpredicted exception occurred."
	end
  end
end