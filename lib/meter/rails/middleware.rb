require 'useragent'
module Meter
  module Rails
    class Middleware
      def initialize(app)
        @app = app
      end

      def call(env)
        request = Rack::Request.new(env)
        Meter::MDC.data['request_id'] = env['action_dispatch.request_id']

        user_agent = UserAgent.parse(request.user_agent)
        Meter::MDC.tags['user_agent_name']     = user_agent.browser
        Meter::MDC.tags['user_agent_version']  = "#{user_agent.browser}_#{user_agent.version}"
        Meter::MDC.tags['user_agent_platform'] = user_agent.platform
        Meter::MDC.data['user_agent']          = user_agent.to_s
        @app.call(env)
      ensure
        Meter::MDC.clear!
      end
    end
  end
end
