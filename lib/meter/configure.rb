require 'meter/configuration'

module Meter

  # Public: Lazy-loads and returns the the configuration instance.
  #
  def self.config
    @config ||= ::Meter::Configuration.new
  end

  # Public: Yields the configuration instance.
  #
  def self.configure(&block)
    yield config
  end

end
