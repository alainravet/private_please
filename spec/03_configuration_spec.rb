require 'spec_helper'

describe PrivatePlease, 'configuration defaults and effects' do
  before() do
    PrivatePlease.install
  end

  before do
    class ConfigTest::Simple
      def public_m ;  private_m()   end
      def private_m; 'SUCCESS'      end
      private_please  :private_m
    end

    def do_the_calls
      ConfigTest::Simple.new.tap do |o|
        o.public_m      # -> inside call
        o.private_m     # -> outside call
      end
    end
  end

#--------------

  it 'is disabled by default' do
    PrivatePlease::Configuration.reset_before_new_test
    PrivatePlease.should_not be_active
  end
  let(:storage) { PrivatePlease.storage }

  context 'when disabled' do

    before { PrivatePlease.activate(false) }
    before { do_the_calls }

    it('is not active') { PrivatePlease.should_not be_active }

    it 'does NOT record the calls to candidates' do
      storage.inside_called_candidates[ 'ConfigTest::Simple'].to_a.should == []
      storage.outside_called_candidates['ConfigTest::Simple'].to_a.should == []
    end
  end

  context 'when enabled' do

    before { PrivatePlease.activate(true) }
    before { do_the_calls }

    it('is active') { PrivatePlease.should be_active }

    it 'DOES record the calls to candidates' do
      storage.inside_called_candidates[ 'ConfigTest::Simple'].to_a.should == [:private_m]
      storage.outside_called_candidates['ConfigTest::Simple'].to_a.should == [:private_m]
    end
  end
end
