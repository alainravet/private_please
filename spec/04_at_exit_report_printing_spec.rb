require 'spec_helper'

describe PrivatePlease, 'Reporting the observation results when the main program exits' do

  before() { PrivatePlease.activate(true) }

  before do
    module ReportingTest
      class Simple
        def call_the_candidate_from_inside
          candidate_1
        end
        def candidate_1;    candidate_2    end
        def candidate_2;      private_m1c  end

        def candidate_3;  private_m1c      end
        def private_m1c ;  'SUCCESS'        end

        def ignored  ;  'never called'  end
        private_please  :candidate_1, :candidate_2, :private_m1c, :candidate_3, :ignored
      end
      class Simple2
        def call_the_candidate_from_inside;  end
        def ignored  ;  'never called'  end
        private_please  :call_the_candidate_from_inside, :ignored
      end
    end

    ReportingTest::Simple.new.tap do |o|
      o.call_the_candidate_from_inside
      o.candidate_3
      o.private_m1c
    end
    ReportingTest::Simple2.new.call_the_candidate_from_inside
  end

  describe 'the activity report' do
    let(:the_report) { PrivatePlease.report }

    specify '#good_candidates is the list of methods that CAN be made private' do
      the_report.good_candidates['ReportingTest::Simple' ].should =~ [:candidate_1, :candidate_2]
      the_report.good_candidates['ReportingTest::Simple2'].should =~ []
    end

    specify '#bad_candidates is the list of methods that CANNOT be made private' do
      the_report.bad_candidates['ReportingTest::Simple' ].should =~ [:private_m1c, :candidate_3]
      the_report.bad_candidates['ReportingTest::Simple2'].should =~ [:call_the_candidate_from_inside]
    end

    specify '#never_called_candidates is the list of methods that were never called' do
      the_report.never_called_candidates['ReportingTest::Simple' ].should == [:ignored]
      the_report.never_called_candidates['ReportingTest::Simple2'].should == [:ignored]
    end
  end

  specify 'at_exit prints the report in the STDOUT'

end