require 'socket'

module Meter
  module Backends
    class Statsd < ::Meter::Backends::Udp

      def self.supported_metrics
        [:counter, :gauge, :timing]
      end

      def convert_to_backend_format(metric)
        rate = "|@#{metric.sample_rate}" unless metric.sample_rate == 1
        "#{metric.name}:#{metric.value}|#{statsd_type(metric)}#{rate}"
      end

      def statsd_type(metric)
        types = {counter: 'c', gauge: 'g', timing: 'ms'}
        types[metric.type]
      end

    end
  end
end
