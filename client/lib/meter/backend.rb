require 'json'
require 'socket'

module Meter
  class Backend

    attr_reader :host, :port

    def initialize(host = '127.0.0.1', port = 8125)
      @host, @port = host, port
      @prefix = "#{::Meter.config.namespace}."
      @socket = UDPSocket.new
    end

    def increment(stat, options = {})
      send_stats stat, 1, :c, options
    end

    def gauge(stat, value, options = {})
      send_stats stat, value, :g, options
    end

    def histogram(stat, value, options = {})
      send_stats stat, value, :h, options
    end

    def log(stat, data = {})
      data = { environment: ::Meter.config.environment, Timestamp: Time.now }.merge data
      data.merge! app: ::Meter.config.namespace, statname: stat
      ::Meter.config.logger.debug { "Logging #{log_file} - #{data}"}
      log_file.open('a') { |f| f.puts(JSON.dump data) }
    end

    private

    def log_file
      ::Meter.config.log_dir.join('application.json.log')
    end

    # See https://github.com/DataDog/dogstatsd-ruby/blob/master/lib/statsd.rb
    def send_stats(stat, delta, type, options = {})
      sample_rate = options[:sample_rate] || 1
      return unless sample_rate == 1 or rand < sample_rate
      stat = stat.to_s.gsub('::', '.').tr(':|@', '_')
      rate = "|@#{sample_rate}" unless sample_rate == 1
      tags = "|##{Array(options[:tags]).join(",")}" if options[:tags]
      send_to_socket "#{@prefix}#{stat}:#{delta}|#{type}#{rate}#{tags}"
    end

    def send_to_socket(message)
      ::Meter.config.logger.debug { "UDP #{self.host}:#{self.port} - #{message}" }
      @socket.send message, 0, self.host, self.port
    end

  end
end
