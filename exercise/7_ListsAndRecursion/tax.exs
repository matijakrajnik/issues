defmodule Tax do
  def add_tax(orders, tax_rates) do
    Enum.map(orders, &calculate_tax(&1, tax_rates))
  end
  
  defp calculate_tax(order, tax_rates) do
    tax_rate = Keyword.get(tax_rates, Keyword.get(order, :ship_to), 0)
    tax = Keyword.get(order, :net_amount) * tax_rate
    total = Keyword.get(order, :net_amount) + tax
    Keyword.put(order, :total_amount, total)
  end
  
  def add_tax_from_file(filename, tax_rates) do
    {:ok, file} = File.open(filename)
    headers = file|>IO.read(:line)|>_split_line|>Enum.map(&String.to_atom(&1))
    Enum.map(IO.stream(file, :line), &_create_one_row(&1, headers))|>add_tax(tax_rates)
  end
  
  defp _split_line(line) do
    line|>String.strip|>String.split(",")
  end

  defp _create_one_row(line, headers) do
    data = line|>_split_line|>Enum.map(&_convert_data(&1))
    Enum.zip(headers, data)
  end

  defp _convert_data(data) do
    cond do
      Regex.match?(~r{^\d+$}, data)           -> String.to_integer(data)
      Regex.match?(~r{^\d+\.\d+$}, data)      -> String.to_float(data)
      << ?: :: utf8, name :: binary >> = data -> String.to_atom(name)
      true -> data                                            
    end
  end
end