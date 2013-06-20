require 'spec_helper'

describe Meter do

  let(:meter)   { Meter }

  describe '.increment' do
    it 'proxies to the backend' do
      meter.increment 'my.key'
    end
  end

end
