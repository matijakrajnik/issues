defmodule SigilV2 do
  def sigil_v(input, _opts) do
    input|>String.rstrip|>String.split("\n")|>Enum.map(&split_and_convert(&1))
  end
  
  defp split_and_convert(line) do
    line|>String.split(",")|>Enum.map(&convert(&1))
  end
  
  defp convert(value) do
    case Float.parse(value) do
      { converted_value, _} -> converted_value
      :error                -> value
    end
  end
end
