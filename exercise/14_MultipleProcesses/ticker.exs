defmodule Ticker do

  @interval 2000   # 2 seconds
  @name     :ticker

  def start do
    pid = spawn(__MODULE__, :generator, [[], []])
    :global.register_name(@name, pid)
  end

  def register(client_pid) do
    send :global.whereis_name(@name), { :register, client_pid }
  end

  def generator(clients_done, clients_todo) do
    receive do
      { :register, pid } ->
        IO.puts "registering #{inspect pid}"
        generator(clients_done, clients_todo ++ [pid])
      after @interval ->
        IO.puts "tick"
        cond do
          length(clients_todo) > 1 ->
            [head | tail] = clients_todo
            send head, { :tick }
            generator(clients_done ++ [head], tail)
          length(clients_todo) == 1 ->
            [head] = clients_todo
            send head, { :tick }
            generator([], clients_done ++ [head])
          length(clients_todo) == 0 ->
            generator(clients_done, [])
        end
    end
  end
end

defmodule Client do

  def start do
    pid = spawn(__MODULE__, :receiver, [])
    Ticker.register(pid)
  end

  def receiver do
    receive do
      { :tick } ->
        IO.puts "tock in client"
        receiver
    end
  end
end
