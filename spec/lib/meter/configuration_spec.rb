require 'spec_helper'
require 'meter/configuration'

describe Meter::Configuration do

  let(:logger) { mock(:logger) }
  let(:config)  { Meter.config }

  before do
    Meter.reset!
  end

  describe '.config' do

    describe '#logger' do
      it 'is an STDOUT logger' do
        Logger.should_receive(:new).with(STDOUT).and_return logger
        config.logger.should be logger
      end

      context 'with Rails' do
        before do
          ensure_module :Rails
          Rails.stub!(:logger).and_return(logger)
        end

        after do
          Object.send(:remove_const, :Rails)
        end

        it 'is the Rails logger' do
          config.logger.should be Rails.logger
        end
      end
    end

    describe '#primary_backend and #secondary_backend' do
      it 'is a Backend' do
        config.primary_backend.should be_instance_of Meter::Backend
        config.secondary_backend.should be_instance_of Meter::Backend
      end

      it 'has the default host' do
        config.primary_backend.host.should == '127.0.0.1'
        config.secondary_backend.host.should == '127.0.0.1'
      end

      it 'has the default namespace' do
        config.primary_backend.namespace.should == nil
        config.secondary_backend.namespace.should == nil
      end

      it 'has the default port' do
        config.primary_backend.port.should == 8125
        config.secondary_backend.port.should == 8126
      end
    end

  end
end
