require 'useragent'

module Meter
  module Rails
    class Middleware
      def initialize(app)
        @app = app
      end

      def call(env)
        request = Rack::Request.new(env)
        Meter::MDC.data['request_id']   = env['action_dispatch.request_id']
        Meter::MDC.data['pid']          = Process.pid
        Meter::MDC.data['ip']           = request.ip.presence || '?'
        Meter::MDC.data['referer']      = request.referer
        Meter::MDC.data['url']          = request.url
        Meter::MDC.data['xhr']          = request.xhr?

        store_user_agent_data(request)

        @app.call(env)
      ensure
        Meter::MDC.clear!
      end

      def store_user_agent_data(request)
        user_agent = UserAgent.parse(request.user_agent)
        Meter::MDC.data['user_agent_name']     = user_agent.browser
        Meter::MDC.data['user_agent_platform'] = user_agent.platform
        Meter::MDC.data['user_agent_bot']      = user_agent.bot?
        Meter::MDC.data['user_agent_version']  = "#{user_agent.browser}_#{user_agent.version}"

        Meter::MDC.data['user_agent']          = user_agent.to_s
      end
    end
  end
end
