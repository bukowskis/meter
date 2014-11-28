require 'spec_helper'

describe Meter::Backend do

  let(:backend) { Meter.config.primary_backend }

  describe '#increment' do
    it 'works and I did not make any mistakes when copy and pasting the backend from StatsD' do
      backend.increment 'my.counter'
    end
  end

  describe '#namespace' do
    it 'can be overriden' do
      Meter.config.namespace = 'ping'
      expect(backend.namespace).to eq 'ping'
    end
  end

  describe '#environment' do
    it 'can be overriden' do
      Meter.config.environment = 'wow'
      expect(backend.environment).to eq 'wow'
    end
  end

  describe '#log' do
    it 'adds the environment' do
      expect(backend).to receive(:send_to_socket).with({ environment: :test, app: :rspec, name: 'wonderful.thing'}.to_json)
      backend.log 'wonderful.thing'
    end
  end

  describe '#increment_and_log' do
    it 'increments' do
      expect(backend).to receive(:increment).with('some.thing')
      backend.increment_and_log('some.thing', more: :things)
    end

    it 'logs' do
      expect(backend).to receive(:log).with('some.thing', more: :things)
      backend.increment_and_log('some.thing', more: :things)
    end
  end

end
