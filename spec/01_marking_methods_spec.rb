require 'spec_helper'

describe PrivatePlease, 'marking methods' do

  it('records the candidates and associate them to the owning class') do
    module Marking
      class Simple1
        def foo ; 'foo' end
        def bar ; 'bar' end
        def buz ; 'bar' end
        private_please  :bar, :buz
      end
    end
    PrivatePlease.candidates['Marking::Simple1'].should == [:bar, :buz]
  end

  it('does not record invalid candidates (method not found in the class)') do
    module Marking
      class Simple2
        def foo ; 'foo' end
        private_please  :foo
        private_please  :invalid_method
      end
    end
    PrivatePlease.candidates['Marking::Simple2'].should == [:foo]
  end

end