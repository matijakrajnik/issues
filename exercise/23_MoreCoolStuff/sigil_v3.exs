defmodule SigilV3 do
  def sigil_v(input, []) do
    input|>String.rstrip|>String.split("\n")|>Enum.map(&split_and_convert(&1))
  end
  def sigil_v(input, 'h') do
    [headers | data] = input|>String.rstrip|>String.split("\n")
    data|>Enum.map(&create_entrie(String.split(&1, ","), String.split(headers, ",")))
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
  
  defp create_entrie(data, headers) do
    List.zip([headers|>Enum.map(&String.to_atom(&1)), data|>Enum.map(&convert(&1))])
  end
end
