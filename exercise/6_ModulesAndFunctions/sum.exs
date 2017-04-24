defmodule Sum do
  def sum(0), do: 0
  def sum(1), do: 1
  def sum(n), do: n + sum(n-1)
end