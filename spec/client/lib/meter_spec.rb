require 'spec_helper'

describe Meter do

  let(:meter)   { Meter }
  let(:datadog) { Meter.backends.datadog }
  let(:counter) { Meter.backends.counter }
  let(:heka)    { Meter.backends.heka }

  before do
    allow(File).to receive(:open).with '/dev/null/application.json.log', 'a'
  end

  describe '.increment' do
    context 'no options'  do
      it 'proxies to datadog' do
        expect(datadog).to receive(:increment).with('my.key', {})
        meter.increment 'my.key'
      end

      it 'does not proxy to counter' do
        expect(counter).not_to receive(:increment)
        meter.increment 'my.key'
      end

      it 'does not proxy to heka' do
        expect(heka).not_to receive(:increment)
        meter.increment 'my.key'
      end
    end

    context 'when given an id as option'  do
      it 'proxies to datadog without ID' do
        expect(datadog).to receive(:increment).with('my.key', {})
        meter.increment 'my.key', id: 456
      end

      it 'proxies to counter with ID' do
        expect(counter).to receive(:increment).with("#{::Meter.config.namespace}.my.key.123", {})
        meter.increment 'my.key', id: 123
      end

      it 'does not proxy to heka' do
        expect(heka).not_to receive(:increment)
        meter.increment 'my.key'
      end
    end
  end

  describe '.gauge' do
    it 'proxies to datadog' do
      expect(datadog).to receive(:gauge).with('my.key', 42, {})
      meter.gauge 'my.key', 42
    end

    it 'does not proxy to counter' do
      expect(counter).not_to receive(:gauge)
      meter.gauge 'my.key', 33
    end

    it 'does not proxy to heka' do
      expect(heka).not_to receive(:gauge)
      meter.gauge 'my.key', 33
    end
  end

  describe '.histogram' do
    it 'proxies to datadog' do
      expect(datadog).to receive(:histogram).with('my.key', 42, {})
      meter.histogram 'my.key', 42
    end

    it 'does not proxy to counter' do
      expect(counter).not_to receive(:histogram)
      meter.histogram 'my.key', 33
    end

    it 'does not proxy to heka' do
      expect(heka).not_to receive(:histogram)
      meter.histogram 'my.key', 33
    end
  end

  describe '.log' do
    it 'proxies to heka' do
      expect(heka).to receive(:log).with 'my.key', my: :data
      meter.log 'my.key', { my: :data }
    end

    it 'does not proxy to datadog' do
      expect(datadog).not_to receive(:log)
      meter.log 'my.key', { my: :data }
    end

    it 'does not proxy to counter' do
      expect(counter).not_to receive(:log)
      meter.log 'my.key', { my: :data }
    end
  end

end
