defprotocol Caesar do  
  def encrypt(value, shift)
  def rot13(value)
end

defimpl Caesar, for: BitString do
  def encrypt(string, shift) do
    string
    |>to_charlist
    |>Enum.map(&(Caesar.Helper.shift_one_char(&1, shift)))
    |>to_string
  end
  
  def rot13(string) do
    encrypt(string, 13)
  end
end

defimpl Caesar, for: List do
  def encrypt(list, shift) do
    list
    |>Enum.map(&(Caesar.Helper.shift_one_char(&1, shift)))
  end
  
  def rot13(list) do
    encrypt(list, 13)
  end
end

defmodule Caesar.Helper do
  @alphabet_length 26
  @downcase_start ?a
  @downcase_end ?z
  @upercase_start ?A
  @upercase_end ?Z
  
  def shift_one_char(char, shift) when char in @downcase_start..@downcase_end and char + shift <= @downcase_end, do: char + shift
  def shift_one_char(char, shift) when char in @downcase_start..@downcase_end and char + shift > @downcase_end, do: char + shift - @alphabet_length
  def shift_one_char(char, shift) when char in @upercase_start..@upercase_end and char + shift <= @upercase_end, do: char + shift
  def shift_one_char(char, shift) when char in @upercase_start..@upercase_end and char + shift > @upercase_end, do: char + shift - @alphabet_length
  def shift_one_char(char, _), do: char
  
  def test_caesar(test_words \\ ["test", "TEST", 'test', 'TEST', "TeSt", 'TeSt']) do
    test_words|>Enum.map(&(IO.puts "ROT13 of #{inspect &1} is: #{inspect Caesar.rot13(&1)}"))
  end
end

defmodule WordScanner do  
  def scan(file_path \\ "word_list.txt") do
    words = File.read!(file_path)|>String.split
    
    words
    |>Enum.map(&(spawn_link __MODULE__, :check_for_word, [self, String.strip(&1), words]))
    |>wait_for_responses
  end
  
  def check_for_word(sender_pid, word, words) do
    rot13_encrypted = Caesar.rot13(word)
    words
    |>Enum.find(&(String.strip(&1) == rot13_encrypted))
    |>send_result(word, sender_pid)
  end
  
  defp wait_for_responses(pids) do
    pids
    |>Enum.map(fn (pid) -> 
                             receive do
                               {^pid, {:ok, message}} -> IO.puts message
                               {^pid, {:not_found}}   -> nil
                               after 1000             -> nil
                             end
               end)
  end
  
  defp send_result(nil, _, sender_pid), do: send sender_pid, {self, {:not_found}} 
  defp send_result(rot13_encrypted, word, sender_pid) do
    send sender_pid, {self, {:ok, "ROT13(#{word}) = #{String.strip(rot13_encrypted)}"}}
  end
end
