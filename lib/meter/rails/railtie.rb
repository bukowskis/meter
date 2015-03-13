module Meter
  module Rails
    class Railtie < ::Rails::Railtie
      initializer "meter.insert_middleware" do |app|
        if ActionDispatch.const_defined? :RequestId
          app.config.middleware.insert_after ActionDispatch::RequestId, Meter::Rails::Middleware
        else
          app.config.middleware.insert_after Rack::MethodOverride, Meter::Rails::Middleware
        end

        if ActionDispatch.const_defined?(:Reloader) && ActionDispatch::Reloader.respond_to?(:to_cleanup)
          ActionDispatch::Reloader.to_cleanup do
            Meter::MDC.clear!
          end
        end
      end
    end
  end
end
