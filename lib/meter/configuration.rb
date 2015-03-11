require 'logger'
require 'pathname'

module Meter
  class Configuration

    attr_reader :options

    def initialize(options = {})
      @options = options
    end

    def logger
      @logger ||= options[:logger] || default_logger
    end
    attr_writer :logger

    def namespace
      @namespace ||= options[:namespace] || default_namespace
    end
    attr_writer :namespace

    def environment
      @environment ||= options[:environment] || default_environment
    end
    attr_writer :environment

    def log_dir
      @log_dir ||= (::Pathname.new(options[:log_dir]) if options[:log_dir]) || default_log_dir
    end

    def log_dir=(new_dir)
      @log_dir = Pathname.new new_dir
    end

    def hostname
      @hostname ||= options[:hostname] || default_hostname
    end
    attr_writer :hostname

    private

    def default_logger
      return ::Rails.logger if defined?(::Rails)
      ::Logger.new STDOUT
    end

    def default_namespace
      :meter
    end

    def default_environment
      return ::Rails.env if defined?(::Rails)
      return ENV['RACK_ENV'] if ENV['RACK_ENV'].to_s != ''
      return ENV['NODE_CHEF_ENVIRONMENT'] if ENV['NODE_CHEF_ENVIRONMENT'].to_s != ''
      'unknown'
    end

    def default_log_dir
      return ::Rails.root.join('log') if defined?(::Rails)
      log_subdir = ::Pathname.pwd.join('log')
      return log_subdir if log_subdir.directory?
      Pathname.new '/dev/null'
    end

    def default_hostname
      return File.read('/etc/me').strip       if File.readable?('/etc/me')
      return File.read('/etc/hostname').strip if File.readable?('/etc/hostname')
      `hostname -f`.strip
    end
  end
end
