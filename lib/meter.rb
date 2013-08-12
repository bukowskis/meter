require 'meter/configuration'

# A generic wrapper for Statsd-like gauges and counters.
#
module Meter
  extend self

  def increment(key, options = {})
    primary.increment key, options
  end

  def increment!(key, options = {})
    primary.increment key, options
    secondary.increment key, options
  end

  def increment_with_id(key_with_id, options = {})
    key_without_id = key_with_id.split('.')[0 .. -2].join('.')
    primary.increment key_without_id, options
    secondary.increment key_with_id, options
  end

  def count(key, delta, options = {})
    primary.count key, delta, options
  end

  def count!(key, delta, options = {})
    primary.count key, delta, options
    secondary.count key, delta, options
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
