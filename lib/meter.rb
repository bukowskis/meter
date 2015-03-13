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

  def self.increment(key, value: 1, sample_rate: 1, tags: {}, data: {})
    metric = Metric::Counter.new(name: key, value: value, sample_rate: sample_rate, tags: tags, data: data)
    backends.each {|backend| backend.emit_metric(metric)}
    metric
  rescue => exception
    ::Meter.config.logger.error exception.inspect
  end

  def self.gauge(key, value, sample_rate: 1, tags: {}, data: {})
    metric = Metric::Gauge.new(name: key, value: value, sample_rate: sample_rate, tags: tags, data: data)
    backends.each {|backend| backend.emit_metric(metric)}
    metric
  rescue => exception
    ::Meter.config.logger.error exception.inspect
  end

  def self.histogram(key, value, sample_rate: 1, tags: {}, data: {})
    metric = Metric::Histogram.new(name: key, value: value, sample_rate: sample_rate, tags: tags, data: data)
    backends.each {|backend| backend.emit_metric(metric)}
    metric
  rescue => exception
    ::Meter.config.logger.error exception.inspect
  end

end
