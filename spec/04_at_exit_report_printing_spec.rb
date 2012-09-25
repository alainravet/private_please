require 'spec_helper'

describe PrivatePlease, 'Reporting the observation results when the main program exits' do

  class ReportingTest::Simple
    def public_m    ;  private_m1a()    end
    def private_m1a ;    private_m1b    end
    def private_m1b ;      private_m1c  end

    def private_m   ;  private_m1c      end
    def private_m1c ;  'SUCCESS'        end

    def ignored  ;  'never called'  end
    private_please  :private_m1a, :private_m1b, :private_m1c, :private_m, :ignored
  end

  before() { PrivatePlease.activate(true) }
  before do
    ReportingTest::Simple.new.public_m
    ReportingTest::Simple.new.private_m
    ReportingTest::Simple.new.private_m1c
  end

  describe 'the activity report' do
    let(:the_report) { PrivatePlease.report }

    specify '#good_candidates is the list of methods that CAN be made private' do
      the_report.good_candidates['ReportingTest::Simple'].
          should =~ [:private_m1a, :private_m1b]
    end

    specify '#bad_candidates is the list of methods that CANNOT be made private' do
      the_report.bad_candidates['ReportingTest::Simple'].
          should =~ [:private_m1c, :private_m]
    end

    xspecify '#never_called_candidates is the list of methods that were never called' do
      the_report.never_called_candidates['ReportingTest::Simple'].
          should == [:ignored]
    end
  end

  specify 'at_exit prints the report in the STDOUT'

end