defmodule Issues.TableFormatter do  
  def display_result(data, columns_for_display) do
    column_widths = calculate_column_widths(data, columns_for_display)
  end
  
  defp calculate_column_widths(data, columns_for_display) do
    for column <- columns_for_display, do: (%{column => find_max_length(data, column)})
    |>Enum.reduce(fn(x, acc) -> Map.merge(x, acc) end)
  end
  
  defp find_max_length(data, key) do
    Enum.max_by(data, &(&1[key]|>to_string|>String.length))[key]|>to_string|>String.length
  end
end