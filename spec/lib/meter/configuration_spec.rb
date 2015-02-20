require 'spec_helper'

describe Meter do

  let(:dummy)  { double(:dummy) }
  let(:config) { Meter::Configuration.new }

  describe '#logger' do
    context 'default' do
      it 'is a native Ruby Logger instance' do
        expect(config.logger).to be_instance_of ::Logger
      end

      it 'logs to standard output' do
        device = config.logger.instance_variable_get('@logdev')
        expect(device.dev.inspect).to eq '#<IO:<STDOUT>>'
      end

      context 'with Rails' do
        before do
          stub_const 'Rails', double(:rails, logger: dummy)
        end

        it 'is the Rails environment' do
          expect(config.logger).to eq dummy
        end
      end
    end

    context 'specifying a custom logger' do
      before do
        config.logger = dummy
      end

      it 'is the custom logger' do
        expect(config.logger).to eq dummy
      end
    end
  end

  describe '#namespace' do
    context 'default' do
      it 'is meter' do
        expect(config.namespace).to eq :meter
      end
    end

    context 'specifying a custom namespace' do
      before do
        config.namespace = dummy
      end

      it 'is the custom namespace' do
        expect(config.namespace).to eq dummy
      end
    end
  end

  describe '#environment' do
    context 'default' do
      it 'is unknown' do
        expect(config.environment).to eq 'unknown'
      end

      context 'with NODE_CHEF_ENVIRONMENT' do
        before do
          ENV['NODE_CHEF_ENVIRONMENT'] = 'chef_ftw'
        end

        it 'is derived from NODE_CHEF_ENVIRONMENT' do
          expect(config.environment).to eq 'chef_ftw'
        end

        context 'with RACK_ENV' do
          before do
            ENV['RACK_ENV'] = 'rack_ftw'
          end

          it 'is derived from RACK_ENV' do
            expect(config.environment).to eq 'rack_ftw'
          end

          context 'with Rails' do
            before do
              stub_const 'Rails', double(:rails, env: 'rails_ftw')
            end

            it 'is the Rails environment' do
              expect(config.environment).to eq 'rails_ftw'
            end
          end
        end
      end
    end

    context 'specifying a custom environment' do
      before do
        config.environment = dummy
      end

      it 'is the custom environment' do
        expect(config.environment).to eq dummy
      end
    end
  end

  describe '#log_dir' do
    context 'default' do
      it 'is /dev/null' do
        expect(config.log_dir).to eq Pathname.new('/dev/null')
      end
    end

    context 'specifying a custom log_dir' do
      before do
        config.log_dir = '/tmp/something'
      end

      it 'is the custom log_dir' do
        expect(config.log_dir).to eq Pathname.new('/tmp/something')
      end
    end

    context 'with a local log directory' do
      before do
        allow(::Pathname).to receive(:pwd).and_return Pathname.new('/tmp/meter')
        FileUtils.makedirs '/tmp/meter/log'
      end

      after do
        FileUtils.rmdir '/tmp/meter/log'
      end

      it 'is the local log directory' do
        expect(config.log_dir).to eq Pathname.new('/tmp/meter/log')
      end

      context 'with Rails' do
        before do
          stub_const 'Rails', double(:rails, root: Pathname.new('/rails/ftw'))
        end

        it 'is the Rails log dir' do
          expect(config.log_dir).to eq Pathname.new('/rails/ftw/log')
        end
      end
    end
  end

end
