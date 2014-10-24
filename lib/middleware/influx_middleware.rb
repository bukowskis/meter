require 'influxdb'
require 'active_support'

class InfluxMiddleware
  def initialize(app)
    @app = app
    @influxdb = influxdb = InfluxDB::Client.new ENV['INFLUXDB_DATABASE'], host: ENV['INFLUXDB_HOST'], username: ENV['INFLUXDB_USER'], password: ENV['INFLUXDB_PASSWORD'], async: true
  end

  def call(env)
    @influxdb.write_point env['name'], env.except('name')
    @app.call(env)
  end
end
