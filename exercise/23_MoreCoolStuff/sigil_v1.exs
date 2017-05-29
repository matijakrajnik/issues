defmodule SigilV1 do
  def sigil_v(input, _opts) do
    input|>String.rstrip|>String.split("\n")|>Enum.map(&String.split(&1, ","))
  end
end
