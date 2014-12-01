require 'meter/backend'
require 'ostruct'

module Meter

  # Holds the currently known backends.
  #
  def self.backends
    @backends ||= ::OpenStruct.new(
    datadog: ::Meter::Backend.new('127.0.0.1', 8125),
    counter: ::Meter::Backend.new('127.0.0.1', 3333),
    heka:    ::Meter::Backend.new('127.0.0.1', 8128),
  )
  end

end
