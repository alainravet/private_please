require 'spec_helper'

describe PrivatePlease, 'marking methods to observe with the `private_please` command' do

  let(:storage) { PrivatePlease.storage }

  it('associates the marked methods and their owning class, and stores them in the `candidates list') do
    module MarkingTest
      class Simple1
        def foo ; 'foo' end
        def bar ; 'bar' end
        def buz ; 'bar' end
        private_please  :bar, :buz    # <<-- what we test
      end
    end
    storage.candidates.
        should == {'MarkingTest::Simple1' =>[:bar, :buz],
                   'Class'                =>[:bar, :buz]  #TODO : fix this (should not be present)
    }
  end


  it('rejects invalid candidates (method not found in the class)') do
    module MarkingTest
      class Simple2
        def foo ; 'foo' end
        private_please  :foo               # <<-- what we test
        private_please  :invalid_method    # <<-- what we test
      end
    end
    storage.candidates.
        should == {'MarkingTest::Simple2' =>[:foo],
                   'Class'                =>[:foo]  #TODO : fix this (should not be present)
    }
  end

end