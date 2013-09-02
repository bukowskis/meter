require 'spec_helper'

describe Meter do

  let(:meter)     { Meter }
  let(:primary)    { Meter.config.primary_backend }
  let(:secondary) { Meter.config.secondary_backend }
  let(:counter) { Meter.config.counter_backend }

  describe '.increment' do
    context "when given an id as option"  do
      it "proxies to the counter with the id" do
        counter.should_receive(:increment).with("my.key.123", {})
        meter.increment 'my.key', :id => 123
      end

      it "proxies to the primary and secondary without the id" do
        primary.should_receive(:increment).with("my.key", {})
        secondary.should_receive(:increment).with("my.key", {})
        meter.increment 'my.key', :id => 123
      end
    end

    context "when id is NOT given as an option"  do
      it "doesn't proxy to the counter at all" do
        counter.should_not_receive(:increment)
        meter.increment 'my.key'
      end

      it "proxies to the primary and secondary" do
        primary.should_receive(:increment).with("my.key", {})
        secondary.should_receive(:increment).with("my.key", {})
        meter.increment 'my.key'
      end
    end
  end
end
