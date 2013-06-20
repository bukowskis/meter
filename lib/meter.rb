require 'meter/configuration'

# A generic wrapper for Statsd-like gauges and counters.
#
module Meter
  extend self

  def increment(key, delta = 1, options = {})
    delta = delta.to_i
    if delta > 1
      primary.count key, delta, options
    else
      primary.increment key, options
    end
  end

  def increment!(key, delta = 1, options = {})
    delta = delta.to_i
    if delta > 1
      primary.count key, delta, options
      secondary.count key, delta, options
    else
      primary.increment key, options
      secondary.increment key, options
    end
  end

  def gauge(key, value, options = {})
    primary.gauge key, value, options
  end

  private

  def primary
    config.primary_backend
  end

  def secondary
    config.secondary_backend
  end

end
