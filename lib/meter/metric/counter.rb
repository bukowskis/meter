module Meter
  module Metric
    class Counter < Meter::Metric::Base

      def type
        :counter
      end

      private

      def default_value
        1
      end

    end
  end
end
