defmodule MyEnum do
  def all?([], _fun), do: true
  def all?([head | tail], func) do
    if func.(head) do
	  all?(tail, func)
	else
	  false
	end
  end

  def each([], _func), do: []
  def each([head | tail], func), do: [func.(head) | each(tail, func)]

  def filter([], _func), do: []
  def filter([head | tail], func) do
    if func.(head) do
	  [head | filter(tail, func)]
	else
	  filter(tail, func)
	end
  end

  def split(list, n) when n >= 0, do: _split(list, [], n)
  defp _split([], first_list, _n), do: {Enum.reverse(first_list), []}
  defp _split(last_list, first_list, 0), do: {Enum.reverse(first_list), last_list}
  defp _split([head | tail], first_list, n), do: _split(tail, [head | first_list], n - 1)

  def split(list, n) when n < 0, do: _split_neg(Enum.reverse(list), [], - n)
  defp _split_neg([], first_list, _n), do: {[], first_list}
  defp _split_neg(last_list, first_list, 0), do: {Enum.reverse(last_list), first_list}
  defp _split_neg([head | tail], first_list, n), do: _split_neg(tail, [head | first_list], n - 1)
  
  def take(list, n) when n >= 0, do: _take(list, [], n)
  def take(list, n) when n < 0, do: Enum.reverse(_take(Enum.reverse(list), [], - n))
  defp _take([], result, _n), do: Enum.reverse(result)
  defp _take(_list, result, 0), do: Enum.reverse(result)
  defp _take([head | tail], result, n), do: _take(tail, [head | result], n - 1)
end