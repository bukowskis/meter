require 'influxdb'

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
