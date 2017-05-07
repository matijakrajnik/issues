defmodule BasicProcess do
  def send_back do
    receive do
      {sender, message} -> send(sender, message)
      after 500 -> IO.puts "Timeout"
    end
  end
  
  def run do
    process1 = spawn(BasicProcess, :send_back, [])
    process2 = spawn(BasicProcess, :send_back, [])
    
    send(process1, {self(), :tom})
    send(process2, {self(), :jerry})
    
    receive do
      message -> IO.puts(message)
    end
    receive do
      message -> IO.puts(message)
    end
  end
end

BasicProcess.run