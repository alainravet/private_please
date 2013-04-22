require 'spec_helper'

describe PrivatePlease, 'calling observed methods and separating the outside/inside calls' do

  before { PrivatePlease.activate(true) }

  before do
    module CallingTest
      class Simple
        def call_the_candidate_from_inside
          candidate_3
        end
        def candidate_3; 'SUCCESS' end  # << observed method
        private_please  :candidate_3
      end
      class AnotherClass
        def call_the_candidate_from_outside
          CallingTest::Simple.new.candidate_3
        end
      end
    end
  end

#--------------
  context 'from INSIDE the class' do
#--------------

    it('records the call to the observed method as an inside call') do
      CallingTest::Simple.new.call_the_candidate_from_inside
      assert_calls_detected :inside  => {'CallingTest::Simple' => [:candidate_3]},
                            :outside => {}
    end

    it('records multiple calls only once') do
      CallingTest::Simple.new.call_the_candidate_from_inside
      CallingTest::Simple.new.call_the_candidate_from_inside
      assert_calls_detected :inside  => {'CallingTest::Simple' => [:candidate_3]},
                            :outside => {}
    end
  end


#--------------
  context 'from OUTSIDE the class' do
#--------------

    before { @result = CallingTest::AnotherClass.new.call_the_candidate_from_outside }

    it 'goes thru (as the method is still public)' do
      @result.should == 'SUCCESS'
    end

    it('records the call to the observed method as an outside call') do
      assert_calls_detected :inside  => {},
                            :outside => {'CallingTest::Simple' => [:candidate_3]}
    end

    it('records multiple calls only once') do
      2.times{ CallingTest::Simple.new.candidate_3 }
      assert_calls_detected :inside  => {},
                            :outside => {'CallingTest::Simple' => [:candidate_3]}
    end
  end

end