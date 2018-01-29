require 'json'

module Meter
  module Backends
    class JsonLog < ::Meter::Backends::Base

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
        log_file.open('a') { |f| f.puts(JSON.dump(data)) }
      end

      private

      def log_file
        ::Meter.config.log_dir.join('application.json.log')
      end

    end
  end
end
