require 'meter/configuration'

# A generic wrapper for Statsd-like gauges and counters.
#
module Meter
  extend self

  def increment(key, options = {})
    id = options.delete(:id)
    primary.increment key, options
    if id
      secondary.increment "#{key}.#{id}", options
    end
  end

  def count(key, delta, options = {})
    id = options.delete(:id)
    primary.count key, delta, options
    if id
      secondary.count "#{key}.#{id}", delta, options
    end
  end

  def gauge(key, value, options = {})
    primary.gauge key, value, options
  end

  def histogram(key, value, options = {})
    primary.histogram key, value, options
  end

  private

  def primary
    config.primary_backend
  end

  def secondary
    config.secondary_backend
  end

end
