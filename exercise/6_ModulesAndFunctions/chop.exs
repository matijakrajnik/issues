defmodule Chop do
  def guess(x, range=first..last) do
    guess = div(last+first,2)
    IO.puts("Is it #{guess}")
    helper(x, guess, range)
  end
  
  def helper(x, x, _) do
    IO.puts(x)
  end
  
  def helper(x, guess, first..last) when guess < x do
    guess(x, guess+1..last)
  end
  
  def helper(x, guess, first..last) when guess > x do
    guess(x, first..guess-1)
  end
end