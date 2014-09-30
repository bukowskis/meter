require 'json'
class MessageHandler < EM::Connection
  def receive_data(data)
    data = JSON.parse(data)
    Backend.run(data)
  end
end
