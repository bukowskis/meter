module Meter
  module Metric
    class Timing < Meter::Metric::Base

      def type
        :timing
      end

    end
  end
end
