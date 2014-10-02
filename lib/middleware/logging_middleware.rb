require 'logger'

class LoggingMiddleware
  def initialize(app)
    @app = app
    @logger = Logger.new STDOUT
  end

  def call(env)
    @logger.info env
    @app.call(env)
  end
end
