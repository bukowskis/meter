module Meter
  module Rails
    class Middleware
      def initialize(app)
        @app = app
      end

      def call(env)
        @app.call(env)
      ensure
        Meter::MDC.clear!
      end
    end
  end
end
