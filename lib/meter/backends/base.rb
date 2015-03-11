module Meter
  module Backends
    class Base

      def self.supported_metrics
        []
      end

      def supported_metric?(metric)
        self.class.supported_metrics.include? metric.type
      end

      def emit_metric(metric)
        return unless supported_metric? metric
        metric_data = convert_to_backend_format(metric)
        output_data(metric_data)
      end

      def convert_to_backend_format(metric)
      end

      def output_data(data)
      end

    end
  end
end
