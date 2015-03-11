module Meter

  # Holds the currently known backends.
  #
  def self.backends
    @backends = [
      ::Meter::Backends::Datadog.new('127.0.0.1', 8125),
      ::Meter::Backends::JsonLog.new
    ]
  end

end
