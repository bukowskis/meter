require 'active_support'
require 'eventmachine'

require_relative './message_handler'

class UdpListener
  def initialize(host = '127.0.0.1', port = ENV['METER_PORT'])
    @host = host
    @port = port
  end

  def run
    EM::open_datagram_socket(@host, @port, MessageHandler)
  end
end
