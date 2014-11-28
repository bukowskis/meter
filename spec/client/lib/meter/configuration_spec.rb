require 'spec_helper'
require 'meter/configuration'

describe Meter::Configuration do

  let(:logger) { double(:logger) }
  let(:config)  { Meter.config }

  before do
    Meter.reset!
  end

  describe '.config' do

    describe '#logger' do
      it 'is an STDOUT logger' do
        expect(Logger).to receive(:new).with(STDOUT).and_return logger
        expect(config.logger).to be logger
      end

      context 'with Rails' do
        before do
          ensure_module :Rails
          allow(Rails).to receive(:logger).and_return(logger)
        end

        after do
          Object.send(:remove_const, :Rails)
        end

        it 'is the Rails logger' do
          expect(config.logger).to be Rails.logger
        end
      end
    end

    describe '#primary_backend and #secondary_backend' do
      it 'is a Backend' do
        expect(config.primary_backend).to be_instance_of Meter::Backend
        expect(config.secondary_backend).to be_instance_of Meter::Backend
      end

      it 'has the default host' do
        expect(config.primary_backend.host).to eq('127.0.0.1')
        expect(config.secondary_backend.host).to eq('127.0.0.1')
      end

      it 'has the default namespace' do
        expect(config.primary_backend.namespace).to eq(nil)
        expect(config.secondary_backend.namespace).to eq(nil)
      end

      it 'has the default port' do
        expect(config.primary_backend.port).to eq(8125)
        expect(config.secondary_backend.port).to eq(8126)
      end
    end

  end
end
