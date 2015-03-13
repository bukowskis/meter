require 'socket'

module Meter
  module Backends
    class Datadog < ::Meter::Backends::Statsd

      def self.supported_metrics
        [:counter, :gauge, :timing, :histogram]
      end

      def convert_to_backend_format(metric)
        rate = "|@#{metric.sample_rate}" unless metric.sample_rate == 1
        tags = "|##{convert_tags_to_datadog_format(metric.tags)}" unless metric.tags.empty?
        "#{metric.name}:#{metric.value}|#{statsd_type(metric)}#{rate}#{tags}"
      end

      def convert_tags_to_datadog_format(tags = {})
        tags.map{|key,val| "#{key}:#{val}"}.join(',')
      end

      def statsd_type(metric)
        types = {counter: 'c', gauge: 'g', timing: 'ms', histogram: 'h'}
        types[metric.type]
      end

    end
  end
end
