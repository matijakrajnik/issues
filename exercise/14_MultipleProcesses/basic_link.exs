defmodule BasicLink do
  def send_pid(parent) do
    send(parent, "Hello my parent")
    exit(:boom)
  end
  
  def receive_messages do
    receive do
      message -> IO.puts message
      after 1000 -> IO.puts "Timeout"
    end
    receive_messages
  end
  
  def run do
    spawn_link(BasicLink, :send_pid, [self()])
    :timer.sleep(5000)
    receive_messages
  end
end
  
BasicLink.run