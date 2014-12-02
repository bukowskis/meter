require 'meter/backends'
require 'meter/configure'

module Meter

  def self.increment(key, options = {})
    id = options.delete(:id)
    backends.datadog.increment key, options
    backends.counter.increment("#{key}.#{id}", options) if id

  rescue => exception
    ::Meter.config.logger.error exception.inspect
  end

  def self.gauge(key, value, options = {})
    backends.datadog.gauge key, value, options

  rescue => exception
    ::Meter.config.logger.error exception.inspect
  end

  def self.histogram(key, value, options = {})
    backends.datadog.histogram key, value, options

  rescue => exception
    ::Meter.config.logger.error exception.inspect
  end

  def self.log(key, data)
    backends.heka.log key, data

  rescue => exception
    ::Meter.config.logger.error exception.inspect
  end

end
