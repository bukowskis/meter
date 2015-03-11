module Meter
  module Metric
    class Gauge < Meter::Metric::Base

      def type
        :gauge
      end

    end
  end
end
