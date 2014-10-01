require 'json'
class MessageHandler < EM::Connection
  def receive_data(data)
    data = JSON.parse(data)
    Backend.run(data)
  rescue JSON::ParserError
    puts "That ain't no valid JSON"
  end
end
