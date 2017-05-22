defmodule My do
  defmacro unless(condition, clauses) do
    do_clause   = Keyword.get(clauses, :do, nil)
    else_clause = Keyword.get(clauses, :else, nil)
    quote do
      if unquote(condition) do
        unquote(else_clause)
      else
        unquote(do_clause)
      end
    end
  end
end

defmodule Test do
  require My
  My.unless 1==2 do
    IO.puts "1 != 2"
  else
    IO.puts "1 == 2"
  end
end
