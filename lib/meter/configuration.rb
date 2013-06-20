require 'logger'
require 'meter/backend'

module Meter
  class Configuration

    attr_accessor :logger, :tags
    attr_reader :primary_backend, :secondary_backend

    def initialize(options={})
      @logger = options[:logger] || default_logger
      @primary_backend = Backend.new
      @primary_backend.host = options[:primary_host] || default_host
      @primary_backend.port = options[:primary_port] || default_port
      @secondary_backend = Backend.new
      @secondary_backend.host = options[:secondary_host] || default_host
      @secondary_backend.port = options[:secondary_port] || default_secondary_port
      @tags = options[:tags] || {}
    end

    def primary_host
      primary_backend.host
    end

    def primary_port
      primary_backend.port
    end

    def secondary_host
      secondary_backend.host
    end

    def secondary_port
      secondary_backend.port
    end

    def primary_host=(new_host)
      primary_backend.host = new_host
    end

    def primary_port=(new_port)
      primary_backend.port = new_port
    end

    def secondary_host=(new_host)
      secondary_backend.host = new_host
    end

    def secondary_port=(new_port)
      secondary_backend.port = new_port
    end

    private

    def default_logger
      if defined?(Rails)
        Rails.logger
      else
        Logger.new(STDOUT)
      end
    end

    def default_host
      '127.0.0.1'
    end

    def default_port
      8125
    end

    def default_secondary_port
      3333
    end

  end
end

module Meter

  # Public: Returns the the configuration instance.
  #
  def self.config
    @config ||= Configuration.new
  end

  # Public: Yields the configuration instance.
  #
  def self.configure(&block)
    yield config
  end

  # Public: Reset the configuration (useful for testing).
  #
  def self.reset!
    @config = nil
  end
end
