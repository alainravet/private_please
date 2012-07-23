require 'spec_helper'

describe PrivatePlease, 'configuring PrivatePlease' do
  module Config
    class Simple
      def public_m ;  private_m()   end
      def private_m; 'SUCCESS'      end
      private_please  :private_m
    end
  end

  def do_the_calls
    Config::Simple.new.tap do |o|
      o.public_m      # -> inside call
      o.private_m     # -> outside call
    end
  end

#--------------

  it 'is disabled by default' do
    PrivatePlease::Configuration.reset
    PrivatePlease.should_not be_active
  end

  context 'when disabled' do

    before { PrivatePlease.activate(false) }
    before { do_the_calls }

    it('is not active') { PrivatePlease.should_not be_active }

    it 'does NOT record the calls to candidates' do
      PrivatePlease.inside_called_candidates[ 'Config::Simple'].to_a.should == []
      PrivatePlease.outside_called_candidates['Config::Simple'].to_a.should == []
    end
  end

  context 'when enabled' do

    before { PrivatePlease.activate(true) }
    before { do_the_calls }

    it('is active') { PrivatePlease.should be_active }

    it 'DOES record the calls to candidates' do
      PrivatePlease.inside_called_candidates[ 'Config::Simple'].to_a.should == [:private_m]
      PrivatePlease.outside_called_candidates['Config::Simple'].to_a.should == [:private_m]
    end
  end
end
