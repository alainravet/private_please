require 'spec_helper'

describe "acceptance : standard libs are not tracked" do

  before { PrivatePlease.pp_automatic_mode_enable }
  after  { PrivatePlease.pp_automatic_mode_disable}

  module RequireTest; end
#-----------------

  example 'www' do

    class RequireTest::Case1
      require 'csv'
      def foo ; end
    end

    assert_classes_names ['RequireTest::Case1']
  end

  example 'a local lib earlier on the LOADPATH hides/replaces a gem'
end

