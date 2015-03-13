require 'spec_helper'

describe Meter do

  describe '.should_sample?' do
    it 'is true for a sample rate of 1' do
      expect(Meter.should_sample?(1)).to be true
    end

    it 'is true when rand is below sample rate' do
      allow(Meter).to receive(:rand).and_return(0.5)
      expect(Meter.should_sample?(0.6)).to be true
    end

    it 'is false when rand is above sample rate' do
      allow(Meter).to receive(:rand).and_return(0.5)
      expect(Meter.should_sample?(0.4)).to be false
    end
  end
end
