# stolen from https://github.com/steveklabnik/request_store
module Meter
  module MDC
    def self.tags
      Thread.current[:meter_mdc_tags] ||= {}
    end

    def self.data
      Thread.current[:meter_mdc_data] ||= {}
    end

    def self.clear!
      Thread.current[:meter_mdc_tags] = []
      Thread.current[:meter_mdc_data] = {}
    end

  end
end
