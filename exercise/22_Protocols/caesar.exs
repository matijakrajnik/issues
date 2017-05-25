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
end

test_words = ["test", "TEST", 'test', 'TEST', "TeSt", 'TeSt']

test_words|>Enum.map(&(IO.puts "ROT13 of #{inspect &1} is: #{inspect Caesar.rot13(&1)}"))
