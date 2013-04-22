require 'spec_helper'

describe 'PrivatePlease.report', 'observing an instrumented program activity' do

  def run_the_instrumented_program
    ActivityTest::Simple.new.tap do |o|
      o.not_a_candidate_1
      o.not_a_candidate_2
      o.bad_candidate_3
      o.bad_candidate_6
    end
    ActivityTest::Simple2.new.bad_candidate_too
  end

  before() { PrivatePlease.activate(true) }

  before do
unless defined?(ActivityTest::Simple)
    module ActivityTest
      class Simple
        def not_a_candidate_1;    bad_candidate_3   end
        def not_a_candidate_2;    good_candidate_7  end
      private_please
        def bad_candidate_3;      good_candidate_4  end
        def good_candidate_4;     good_candidate_5  end
        def good_candidate_5;     bad_candidate_6   end
        def bad_candidate_6;      good_candidate_7  end
        def good_candidate_7;                       end
        def ignored_8  ;          'never called'    end
      end

      class Simple2
      private_please
        def bad_candidate_too;                      end
        def ignored_2;            'never called'    end
      end
    end
end
  end

  # Note: test all in 1 go because testing in bits would fail, and it differs from real usage.
  it 'obtains the right info by observing the program activity' do
    run_the_instrumented_program
    the_report = PrivatePlease.report
    {
        :good_candidates  => the_report.good_candidates,
        :bad_candidates   => the_report.bad_candidates,
        :ignored          => the_report.never_called_candidates
    }.should == {
        :good_candidates  => {
            'ActivityTest::Simple'   =>  [:good_candidate_4, :good_candidate_5, :good_candidate_7]
        },
        :bad_candidates   => {
            'ActivityTest::Simple'   =>  [:bad_candidate_3, :bad_candidate_6],
            'ActivityTest::Simple2'  =>  [:bad_candidate_too]
        },
        :ignored          => {
            'ActivityTest::Simple'   =>  [:ignored_8],
            'ActivityTest::Simple2'  =>  [:ignored_2]
        }
    }
  end
end