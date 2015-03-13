require 'meter/backends/base'
require 'meter/backends/udp'
require 'meter/backends/statsd'
require 'meter/backends/datadog'
require 'meter/backends/json_log'
require 'meter/configure'
require 'meter/mdc'
require 'meter/metric/base'
require 'meter/metric/counter'
require 'meter/metric/gauge'
require 'meter/metric/histogram'
require 'meter/metric/timing'

module Meter

  class << self
    def increment(key, value: 1, sample_rate: 1, tags: {}, data: {})
      metric = Metric::Counter.new(name: key, value: value, sample_rate: sample_rate, tags: tags, data: data)
      send_metric_to_backends(metric)
    rescue => exception
      ::Meter.config.logger.error exception.inspect
    end
    alias :track :increment

    def gauge(key, value, sample_rate: 1, tags: {}, data: {})
      metric = Metric::Gauge.new(name: key, value: value, sample_rate: sample_rate, tags: tags, data: data)
      send_metric_to_backends(metric)
    rescue => exception
      ::Meter.config.logger.error exception.inspect
    end

    def histogram(key, value, sample_rate: 1, tags: {}, data: {})
      metric = Metric::Histogram.new(name: key, value: value, sample_rate: sample_rate, tags: tags, data: data)
      send_metric_to_backends(metric)
    rescue => exception
      ::Meter.config.logger.error exception.inspect
    end

    def timing(key, value, sample_rate: 1, tags: {}, data: {})
      metric = Metric::Timing.new(name: key, value: value, sample_rate: sample_rate, tags: tags, data: data)
      send_metric_to_backends(metric)
    rescue => exception
      ::Meter.config.logger.error exception.inspect
    end

    def send_metric_to_backends(metric)
      config.backends.each {|backend| backend.emit_metric(metric)}
      metric
    end

    def should_sample?(sample_rate = 1)
      sample_rate == 1 or rand < sample_rate
    end
  end
end
