defmodule WordFinder do
  def run(module, func, directory, word_to_find) do
    directory
    |>File.ls!
    |>Enum.map(fn(x) -> spawn(module, func, [self, x, directory, word_to_find]) end)
    |>get_results([])
  end
  
  def count_word(parrent, filename, directory, word_to_find) do
    file_path = "#{directory}\\#{filename}"
    send(parrent, {self, {file_path, _count_word(file_path, word_to_find)}})
  end
  defp _count_word(filename, word_to_find) do
    case File.open(filename) do
      {:ok,    data} -> Regex.scan(~r/#{word_to_find}/, IO.read(data, :all))|>length
      {:error, reason} -> IO.puts "failed to open file #{filename}, reason: #{reason}"
    end
  end
  
  defp get_results(processes, results) do
    receive do
      {child, result} when length(processes) > 1 ->
        get_results(List.delete(processes, child), [result | results])
      {_child, result} ->
        [result | results]
    end
  end
  
  def crete_test_files(folder_name) do
    1..50
    |>Enum.map(fn(_x) -> create_file_and_write(folder_name, "cat") end)
    
    1..50
    |>Enum.map(fn(_x) -> create_file_and_write(folder_name, "dog") end)
  end
  defp create_file_and_write(folder, animal) do
    word_number = (:random.uniform * 1000)|>round
    file_path = "#{folder}\\#{word_number}_#{animal}_test_file"
    File.write(file_path, "#{animal}\n"|>String.duplicate(word_number))
  end
end

directory = "test_folder"
word_to_find = "cat"

File.rmdir(directory)
File.mkdir(directory)
WordFinder.crete_test_files(directory)

WordFinder.run(WordFinder, :count_word, directory, word_to_find)
|>Enum.map(fn({filename, count}) -> :io.format "~-40s     ~10B~n", [filename, count] end)