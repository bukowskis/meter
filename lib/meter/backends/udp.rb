require 'json'
require 'socket'

module Meter
  module Backends
    class Udp < ::Meter::Backends::Base

      attr_reader :host, :port

      def initialize(host = '127.0.0.1', port = 8125)
        @host, @port = host, port
      end

      def output_data(data)
        socket.send data, 0, self.host, self.port
      end

      def socket
        Thread.current["meter_socket_#{self.class.name}"] ||= UDPSocket.new
      end

    end
  end
end
