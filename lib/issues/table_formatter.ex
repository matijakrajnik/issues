defmodule Issues.TableFormatter do  
  def display_result(data, columns_for_display) do
    column_widths = calculate_column_widths(data, columns_for_display)
    print_headers(columns_for_display, column_widths)
  end
  
  defp calculate_column_widths(data, columns_for_display) do
    list_of_maps = for column <- columns_for_display, do: (%{column => find_max_length(data, column)})
    Enum.reduce(list_of_maps, fn(x, acc) -> Map.merge(x, acc) end)
  end
  
  defp find_max_length(data, key) do
    Enum.max_by(data, &(&1[key]
    |>to_string
    |>String.length))[key]
    |>to_string
    |>String.length
  end
  
  defp print_headers(columns, widths) do
    (for c <- columns do
      " " <> String.replace(c, "number", "#") <> String.duplicate(" ", (widths[c] - String.length(String.replace(c, "number", "#")) + 1))
    end
    |>Enum.join("|")
    |>String.trim_trailing) <> "\n" <>
    (for c <- columns do
      String.duplicate("-", (widths[c]) + 1)
    end
    |>Enum.join("+-"))
    |>IO.puts
  end
end