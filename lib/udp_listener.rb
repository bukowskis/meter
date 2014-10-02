require 'celluloid'
require 'celluloid/io'
require 'celluloid/autostart'
require 'influxdb'
require 'json'

class UdpListener
  MAX_PACKET_SIZE = 512

  include Celluloid::IO

  execute_block_on_receiver :initialize

  def initialize(addr = '127.0.0.1', port = 8128, &block)
    @block = block

    @socket = UDPSocket.new
    @socket.bind(addr, port)

    async.run
  end

  def run
    loop do
      data, (_, port, addr) = @socket.recvfrom(MAX_PACKET_SIZE)
      begin
        parsed_data = JSON.parse data
        @block.call parsed_data
      rescue JSON::ParserError
        puts "That ain't no valid JSON"
      end
    end
  end
end

