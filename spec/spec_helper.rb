require 'meter'

RSpec.configure do |config|
  config.before do
    Meter.config.logger = Logger.new('/dev/null')
  end
end
