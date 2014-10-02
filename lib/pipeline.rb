require_relative 'middleware/logging_middleware'
require_relative 'middleware/influx_middleware'
require_relative 'middleware/last_middleware'

class Pipeline
  include Celluloid

  attr_accessor :run_list

  def initialize
    initialize_run_list
  end

  def initialize_run_list
    self.run_list = middlewares.reverse.inject do |previous, current|
     current.new previous
   end
  end

  def middlewares
    [LoggingMiddleware, InfluxMiddleware, LastMiddleware]
  end

  def process(data)
    run_list.call(data)
  end
end
