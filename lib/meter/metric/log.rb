module Meter
  module Metric
    class Log < Meter::Metric::Base

      def type
        :log
      end

      private

      def default_value
        1
      end

    end
  end
end
