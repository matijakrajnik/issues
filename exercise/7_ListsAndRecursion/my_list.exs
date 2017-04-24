defmodule MyList do
  def sum([]), do: 0
  def sum([head|tail]), do: head + sum(tail)
  
  def mapsum([], _), do: 0
  def mapsum([head|tail], func), do: func.(head) + mapsum(tail, func)
  
  def max([head]), do: head
  def max([head|tail]), do: max(head, max(tail))
  
  def caesar([], _), do: []
  def caesar([head|tail], n) when head + n <= ?z, do: [head + n | caesar(tail, n)]
  def caesar([head|tail], n) when head + n >= ?z, do: [head + n - 26 | caesar(tail, n)]
  
  def span(from, to) when from == to, do: [from]
  def span(from, to) when from < to, do: [from|span(from + 1, to)]
  def span(from, to) when from > to, do: []
  
  def flatten(list), do: _flatten(list, [])
  defp _flatten([], result), do: result
  defp _flatten([head | tail], result) when is_list(head), do: _flatten(head, _flatten(tail, result))
  defp _flatten([head | tail], result), do: [head | _flatten(tail, result)]
  
  def primes(n) when n >= 2 do
    for x <- span(2, n), Enum.all?(span(2, round(x/2)), &(rem(x, &1) != 0)), do: x
  end	
end