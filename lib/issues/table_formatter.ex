defmodule Issues.TableFormatter do

  @doc """
  Takes a list of data, where each element in list is a Map and list of columns for display which
  also server as headers. We calculate widths for each row based on longest element for given column,
  then we print headers and given data.
  
  ## Example
    iex> data = [%{"a" => 11, "b" => 12, "c" => 13},
    ...>         %{"a" => 21, "b" => 22, "c" => 23}]
    iex> columns_for_display = ["a", "c"]
    iex> Issues.TableFormatter.display_result(data, columns_for_display)
    "a  | c
    ---+----
    11 | 13
    21 | 23"
  """
  def display_result(data, columns_for_display) do
    column_widths = calculate_column_widths(data, columns_for_display)
    print_headers(columns_for_display, column_widths)
    print_data(data, columns_for_display, column_widths)
  end
  
  @doc """
  Function takes data and list of columns for display to calculate widths for each column.
  Returns a Map where column name is key and width for given column name is a value.
  """
  defp calculate_column_widths(data, columns_for_display) do
    list_of_maps = for column <- columns_for_display, do: (%{column => find_max_length(data, column)})
    Enum.reduce(list_of_maps, fn(x, acc) -> Map.merge(x, acc) end)
  end
  
  @doc """
  Returns maximum length of all elements in data with given key value.
  """
  defp find_max_length(data, key) do
    Enum.max_by(data, &(&1[key]
    |>to_string
    |>String.length))[key]
    |>to_string
    |>String.length
  end
  
  @doc """
  Takes list of columns for display and Map with column widths. based on that prints headers and
  line which separates headers from data.
  """
  defp print_headers(columns, widths) do
    (for c <- columns do
      String.pad_trailing(String.replace(c, "number", "#"), (widths[c]))
    end
    |>Enum.join(" | ")
    |>String.trim_trailing) <> "\n" <>
    (for c <- columns do
      String.duplicate("-", (widths[c]) + 1)
    end
    |>Enum.join("+-"))
    |>IO.puts
  end
  
  defp print_data(data, columns, column_widths) do
    for d <- data do
      create_one_line(d, columns, column_widths)
    end
    |>Enum.join("\n")
    |>IO.puts
  end
  
  defp create_one_line(data, columns, column_widths) do
    for c <- columns do
      String.pad_trailing(to_string(data[c]), column_widths[c])
    end
    |>Enum.join(" | ")
  end
end