require 'spec_helper'

describe "acceptance : standard libs are not tracked" do

  before { PrivatePlease.pp_automatic_mode_enable }
  after  { PrivatePlease.pp_automatic_mode_disable}

  module RequireTest; end
#-----------------

  example "the csv **standard library** is required but not tracked" do

    class RequireTest::Case1
      require 'csv'
      def foo ; end
    end

    assert_classes_names ['RequireTest::Case1']
  end

  example "the rspec **gem** is required but not tracked" do

    class RequireTest::Case2
      require 'rspec/autorun'
      def foo ; end
    end

    assert_classes_names ['RequireTest::Case2']
  end

end
