require 'spec_helper'
require 'meter'

describe Meter::Backend do

  let(:backend) { Meter.config.primary_backend }

  before do
    Meter.reset!
  end

  describe '.increment' do
    it 'works and I did not make any mistakes when copy and pasting the backend from StatsD' do
      backend.increment 'my.counter'
    end
  end

end
