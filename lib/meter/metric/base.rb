module Meter
  module Metric
    class Base

      attr_reader   :name
      attr_reader   :tags
      attr_reader   :data
      attr_accessor :value
      attr_accessor :sample_rate

      def type
      end

      def initialize(name:, value: default_value, sample_rate: 1, tags: {}, data: {})
        self.name = name
        self.value = value
        self.sample_rate = sample_rate
        self.tags = tags
        self.data = data
      end

      def name=(new_name)
        # Replace Ruby module scoping with '.' and reserved chars (: | @) with underscores.
        @name = new_name.to_s.gsub('::', '.').tr(':|@', '_')
      end

      def tags=(new_tags)
        @tags = default_tags.merge(new_tags)
      end

      def data=(new_data)
        @data = default_data.merge(new_data)
      end

      private

      def default_value
      end

      def default_tags
        {
          app:         ::Meter.config.namespace,
          environment: ::Meter.config.environment
        }.merge(::Meter::MDC.tags)
      end

      def default_data
        {
          timestamp: Time.now.strftime("%FT%H:%M:%S%:z"),
          host:      ::Meter.config.hostname,
        }.merge(::Meter::MDC.data)
      end


    end
  end
end
