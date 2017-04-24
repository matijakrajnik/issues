defmodule MyString do
  def is_printable?(string), do: Enum.all?(string, &(&1 >= ?  and &1 <= ?~))
  
  def anagram?(word1, word2), do: word1|>String.downcase|>String.to_charlist|>Enum.sort == word2|>String.downcase|>String.to_charlist|>Enum.sort
  
  def calculate(expression), do: _calculate(expression, [])
  defp _calculate([head|tail], first) when head == ?+, do: (first|>Enum.reverse|>List.to_integer) + (tail|>List.to_integer)
  defp _calculate([head|tail], first) when head == ?-, do: (first|>Enum.reverse|>List.to_integer) - (tail|>List.to_integer)
  defp _calculate([head|tail], first) when head == ?*, do: (first|>Enum.reverse|>List.to_integer) * (tail|>List.to_integer)
  defp _calculate([head|tail], first) when head == ?/, do: (first|>Enum.reverse|>List.to_integer) / (tail|>List.to_integer)
  defp _calculate([head|tail], first), do: _calculate(tail, [head|first])
  
  def center(strings) do
    max_length = _get_max_length(strings)
    for string <- strings, do: string|>_add_padding(max_length)|>IO.puts
  end
  defp _get_max_length(strings), do: strings|>Enum.max_by(&(&1|>String.length))|>String.length
  defp _add_padding(string, max_length) do
    current_length = string|>String.length
    pading_length = Integer.floor_div((max_length - (string|>String.length)), 2)
    string|>String.pad_leading(pading_length + current_length)|>String.pad_trailing(2 * pading_length + current_length)
  end
  
  def capitalize_sentences(input) do
    delimeter = ". "
    input|>String.split(delimeter)|>Enum.map(&(String.capitalize(&1)))|>Enum.join(delimeter)
  end
end