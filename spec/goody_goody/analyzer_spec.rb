require 'spec_helper'

describe PrivatePlease::MethodsCallsTracker do
  describe '.instance' do
    it 'is idempotent' do
      first  = PrivatePlease.instance
      second = PrivatePlease.instance

      first.should eq(second)
    end
  end

  describe '.reset' do
    it 'resets the instance' do
      first = PrivatePlease.instance
      PrivatePlease.reset
      second = PrivatePlease.instance

      first.should_not eq(second)
    end
  end

  describe '.exclude_dir' do
    it 'adds a value to #additional_excluded_dirs' do
      PrivatePlease.config.additional_excluded_dirs.should eq ['(eval)', LIB_BASEDIR]
      PrivatePlease.exclude_dir 'foobar'

      PrivatePlease.config.additional_excluded_dirs.should eq ['(eval)', LIB_BASEDIR, 'foobar']
    end
  end
end
