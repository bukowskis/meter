require 'spec_helper'
require 'timecop'

describe Meter::Backend do

  let(:backend) { Meter::Backend.new '127.0.0.1', 330033 }
  let(:socket)  { double :socket }
  let(:file)    { double :file }

  before do
    allow(UDPSocket).to receive(:new).and_return socket
    allow(File).to receive(:open).with('/dev/null/application.json.log', 'a').and_yield file
    allow(socket).to receive(:send)
  end

  describe '#increment' do
    it 'sends UDP' do
      expect(socket).to receive(:send).with 'my.nice.counter:1|c', 0, '127.0.0.1', 330033
      backend.increment 'my.nice.counter'
    end

    it 'logs the event' do
      allow(Meter.config.logger).to receive(:debug).with(no_args()) do |&block|
        expect(block.call).to eq 'UDP 127.0.0.1:330033 - my.beautiful.counter:1|c'
      end
      backend.increment 'my.beautiful.counter'
    end
  end

  describe '#gauge' do
    it 'sends UDP' do
      expect(socket).to receive(:send).with 'my.nice.gauge:42|g', 0, '127.0.0.1', 330033
      backend.gauge 'my.nice.gauge', 42
    end

    it 'logs the event' do
      allow(Meter.config.logger).to receive(:debug).with(no_args()) do |&block|
        expect(block.call).to eq 'UDP 127.0.0.1:330033 - my.beautiful.gauge:55|g'
      end
      backend.gauge 'my.beautiful.gauge', 55
    end
  end

  describe '#histogram' do
    it 'sends UDP' do
      expect(socket).to receive(:send).with 'my.nice.histogram:88|h|#one,two', 0, '127.0.0.1', 330033
      backend.histogram 'my.nice.histogram', 88, tags: %w(one two)
    end

    it 'logs the event' do
      allow(Meter.config.logger).to receive(:debug).with(no_args()) do |&block|
        expect(block.call).to eq 'UDP 127.0.0.1:330033 - my.beautiful.histogram:25|h|#not an array but causes no errors'
      end
      backend.histogram 'my.beautiful.histogram', 25, tags: 'not an array but causes no errors'
    end
  end

  describe '#log' do
    before do
      Timecop.freeze(Time.now)
    end

    after do
      Timecop.return
    end

    it 'writes to the logfile' do
      expect(file).to receive(:puts).with %({"environment":"unknown","Timestamp":"#{Time.now}","app":"meter","statname":"super.bowl"})
      backend.log 'super.bowl'
    end

    it 'respects a custom namespace' do
      expect(file).to receive(:puts).with %({"environment":"unknown","Timestamp":"#{Time.now}","app":"apple","statname":"super.nice"})
      Meter.config.namespace = :apple
      backend.log 'super.nice'
    end

    it 'logs the event' do
      allow(file).to receive(:puts)
      allow(Meter.config.logger).to receive(:debug).with(no_args()) do |&block|
        expect(block.call).to eq %(Logging /dev/null/application.json.log - {:environment=>"unknown", :Timestamp=>#{Time.now}, :app=>:apple, :statname=>"super.bowl"})
      end
      backend.log 'super.bowl'
    end
  end
end
