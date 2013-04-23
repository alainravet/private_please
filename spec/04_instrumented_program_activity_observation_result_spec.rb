require 'spec_helper'

describe 'PrivatePlease.report', 'observing an instrumented program activity' do

  def run_the_instrumented_program
    ActivityTest::Simple.new.tap do |o|
      o.not_a_candidate_1
      o.not_a_candidate_2
      o.class.not_a_candidate_c1
      o.bad_candidate_3
      o.bad_candidate_6
      o.class.bad_candidate_c3
    end
    ActivityTest::Simple2.new.bad_candidate_too
    ActivityTest::Simple2    .bad_candidate_c_too
  end

  before() { PrivatePlease.activate(true) }

  before do

    module ActivityTest
      class Simple
        def not_a_candidate_1;    bad_candidate_3   end
        def not_a_candidate_2;    good_candidate_7  end
        def self.not_a_candidate_c1;
          good_candidate_c2
        end
      private_please
        def bad_candidate_3;      good_candidate_4  end
        def good_candidate_4;     good_candidate_5  end
        def good_candidate_5;     bad_candidate_6   end
        def bad_candidate_6;      good_candidate_7  end
        def good_candidate_7;                       end
        def ignored_8  ;          'never called'    end
        def self.good_candidate_c2;                 end
        def self.bad_candidate_c3;                  end
      end

      class Simple2
      private_please
        def bad_candidate_too;                      end
        def ignored_2;            'never called'    end
        def self.bad_candidate_c_too;               end
      end
    end unless defined?(ActivityTest::Simple)
  end

  # Note: test all in 1 go because testing in bits would fail, and it differs from real usage.
  it 'obtains the right info by observing the program activity' do
    run_the_instrumented_program
    the_report = PrivatePlease.report
    {
        :good_candidates  => the_report.good_candidates,
        :bad_candidates   => the_report.bad_candidates,
        :bad_candidates_c => the_report.bad_candidates_c,
        :ignored          => the_report.never_called_candidates
    }.should == {
        :good_candidates  => {
            'ActivityTest::Simple'   =>  mnames_for([:good_candidate_4, :good_candidate_5, :good_candidate_7])
        },
#:good_candidates_c => {
#    'ActivityTest::Simple'   =>  mnames_for([:good_candidate_c2])
#},
        :bad_candidates   => {
            'ActivityTest::Simple'   =>  mnames_for([:bad_candidate_3, :bad_candidate_6]),
            'ActivityTest::Simple2'  =>  mnames_for([:bad_candidate_too])
        },
        :bad_candidates_c => {
            'ActivityTest::Simple'   =>  mnames_for([:bad_candidate_c3]),
            'ActivityTest::Simple2'  =>  mnames_for([:bad_candidate_c_too])
        },
        :ignored          => {
            'ActivityTest::Simple'   =>  mnames_for([:ignored_8]),    #TODO : uniformize (it currently mixes Sets & Arrays)
            'ActivityTest::Simple2'  =>  mnames_for([:ignored_2])
        }
    }
  end
end