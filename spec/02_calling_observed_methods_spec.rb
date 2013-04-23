require 'spec_helper'

describe PrivatePlease, 'calling observed methods and logging calls in 2 categories : internal or external' do

  before { PrivatePlease.activate(true) }

  before do
    module CallingTest
      class Simple
        def call_the_candidate_from_inside
          candidate_3
          self.class.c_candidate_4
          self.class.good_candidate_c2
          self.class.not_a_candidate_c1
        end
        def self.not_a_candidate_c1;
          good_candidate_c2
        end
        private_please
        def candidate_3;        'SUCCESS' end  # << observed method
        def self.c_candidate_4; 'SUCCESS' end  # << observed method
        def self.good_candidate_c2; 'SUCCESS' end  # << observed method
      end
      class AnotherClass
        def call_the_candidate_from_outside
          CallingTest::Simple.new.candidate_3
          CallingTest::Simple.c_candidate_4
          CallingTest::Simple.not_a_candidate_c1
        end
        def call_the_candidate_from_inside_and_outside
          CallingTest::Simple.new.candidate_3
          CallingTest::Simple.c_candidate_4
          CallingTest::Simple.new.call_the_candidate_from_inside
        end
      end
    end unless defined?(CallingTest::Simple)
  end

  NO_CALLS_OBSERVED = {}

#--------------
  example ('pure internal calls are categorized correctly') do
    CallingTest::Simple.new.call_the_candidate_from_inside
    assert_calls_detected :inside     => {'CallingTest::Simple' => mnames_for([:candidate_3])},
                          :outside    => NO_CALLS_OBSERVED,
                          :inside_c   => {'CallingTest::Simple' => mnames_for([:c_candidate_4, :good_candidate_c2])},
                          :outside_c  => NO_CALLS_OBSERVED
  end

  example ('pure external calls are categorized correctly') do
    CallingTest::AnotherClass.new.call_the_candidate_from_outside
    assert_calls_detected :inside     => NO_CALLS_OBSERVED,
                          :outside    => {'CallingTest::Simple' => mnames_for([:candidate_3])},
                          :inside_c   => {'CallingTest::Simple' => mnames_for([:good_candidate_c2])},
                          :outside_c  => {'CallingTest::Simple' => mnames_for([:c_candidate_4])}
  end

  example('when a method is called both from inside and from outside its class, it is recorded is both categories') do
    CallingTest::AnotherClass.new.call_the_candidate_from_inside_and_outside
    assert_calls_detected :inside     => {'CallingTest::Simple' => mnames_for([:candidate_3])},
                          :outside    => {'CallingTest::Simple' => mnames_for([:candidate_3])},
                          :inside_c   => {'CallingTest::Simple' => mnames_for([:good_candidate_c2, :c_candidate_4])},
                          :outside_c  => {'CallingTest::Simple' => mnames_for([:c_candidate_4])}
  end

end
