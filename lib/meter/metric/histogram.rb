module Meter
  module Metric
    class Histogram < Meter::Metric::Base

      def type
        :histogram
      end
    end
  end
end
