require 'spec_helper'

describe PrivatePlease::MethodsCallsTracker do
  describe '.instance' do
    it 'is idempotent' do
      PrivatePlease.instance.should be
      PrivatePlease.instance.should eq(PrivatePlease.instance)
    end
  end

  describe '.init' do
    it 'resets the instance' do
      i1 = PrivatePlease.instance
      PrivatePlease.reset
      PrivatePlease.instance.should be
      PrivatePlease.instance.should_not eq(i1)
    end
  end
end
