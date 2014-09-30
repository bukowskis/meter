require 'active_support'
require "eventmachine"
require 'logger'
require_relative 'message_handler'

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

class InfluxMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    influxdb = InfluxDB::Client.new ENV['INFLUXDB_DATABASE'], host: ENV['INFLUXDB_HOST'], username: ENV['INFLUXDB_USER'], password: ENV['INFLUXDB_PASSSWORD']
    influxdb.write_point env['name'], env.except('name')
    @app.call(env)
  end
end

class LastMiddleware
  def self.call(env)
  end
end

class Backend

  def add_middleware(middleware)
    middlewares << middleware
  end

  def self.middlewares
    [LoggingMiddleware, InfluxMiddleware, LastMiddleware]
  end


  def self.run(data)
    run_list = middlewares.reverse.inject do |previous, current|
      current.new previous
    end

    run_list.call(data)
  end
end


class UdpServer
  def initialize(host = '127.0.0.1', port = '8126')
    @host = host
    @port = port
  end

  def run
    EM::open_datagram_socket(@host, @port, MessageHandler)
  end
end
