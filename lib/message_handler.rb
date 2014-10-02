require 'json'
require_relative 'pipeline'

class MessageHandler < EM::Connection
  def receive_data(data)
    puts "data"
    data = JSON.parse(data)
    Pipeline.run(data)
  rescue JSON::ParserError
    puts "That ain't no valid JSON"
  end
end
