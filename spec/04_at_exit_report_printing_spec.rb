require 'spec_helper'

describe PrivatePlease, 'Reporting the observation results when the main program exits' do

  before() { PrivatePlease.activate(true) }

  before do
    class ReportingTest::Simple
      def public_m    ;  private_m1a()    end
      def private_m1a ;    private_m1b    end
      def private_m1b ;      private_m1c  end

      def private_m   ;  private_m1c      end
      def private_m1c ;  'SUCCESS'        end

      def ignored  ;  'never called'  end
      private_please  :private_m1a, :private_m1b, :private_m1c, :private_m, :ignored
    end
    class ReportingTest::Simple2
      def public_m ;  end
      def ignored  ;  'never called'  end
      private_please  :public_m, :ignored
    end

    ReportingTest::Simple.new.tap do |o|
      o.public_m
      o.private_m
      o.private_m1c
    end
    ReportingTest::Simple2.new.public_m
  end

  describe 'the activity report' do
    let(:the_report) { PrivatePlease.report }

    specify '#good_candidates is the list of methods that CAN be made private' do
      the_report.good_candidates['ReportingTest::Simple' ].should =~ [:private_m1a, :private_m1b]
      the_report.good_candidates['ReportingTest::Simple2'].should =~ []
    end

    specify '#bad_candidates is the list of methods that CANNOT be made private' do
      the_report.bad_candidates['ReportingTest::Simple' ].should =~ [:private_m1c, :private_m]
      the_report.bad_candidates['ReportingTest::Simple2'].should =~ [:public_m]
    end

    specify '#never_called_candidates is the list of methods that were never called' do
      the_report.never_called_candidates['ReportingTest::Simple' ].should == [:ignored]
      the_report.never_called_candidates['ReportingTest::Simple2'].should == [:ignored]
    end
  end

  specify 'at_exit prints the report in the STDOUT'

end