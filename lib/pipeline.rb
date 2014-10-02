require_relative 'middleware/logging_middleware'
require_relative 'middleware/influx_middleware'
require_relative 'middleware/last_middleware'

class Pipeline

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
