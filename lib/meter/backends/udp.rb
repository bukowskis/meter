require 'json'
require 'socket'

module Meter
  module Backends
    class Udp < ::Meter::Backends::Base

      attr_reader :host, :port

      def initialize(host = '127.0.0.1', port = 8125)
        @host, @port = host, port
        @socket = UDPSocket.new
      end

      def output_data(data)
        @socket.send data, 0, self.host, self.port
      end

    end
  end
end
