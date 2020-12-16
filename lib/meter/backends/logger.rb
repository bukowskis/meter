module Meter
  module Backends
    class Logger < ::Meter::Backends::Base
      def self.supported_metrics
        [:log]
      end

      def convert_to_backend_format(metric)
        {
          statname:    metric.name,
          metric_type: metric.type,
          metric_value: metric.value
        }.merge(metric.data).merge(metric.tags)
      end

      def output_data(data)
        ::Meter.config.logger.info payload: data
      end
    end
  end
end
