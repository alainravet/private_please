__END__
require 'spec_helper'

describe 'PrivatePlease.report', 'observing an instrumented program activity' do

  before() do
    PrivatePlease.activate(true)
    require File.dirname(__FILE__) + '/fixtures/sample_class_for_report'

  end


  example('when a method is called both from inside and from outside its class, it is recorded is both categories') do
    ReportSample::AnotherClass.new.call_the_candidate_from_inside_and_outside
    assert_calls_detected :inside     => {'ReportSample::Simple' => mnames_for([:instance_m_1, :instance_m_2])},
                          :outside    => {'ReportSample::Simple' => mnames_for([:instance_m_1])},
                          :inside_c   => {'ReportSample::Simple' => mnames_for([:class_m_2, :class_m_1])},
                          :outside_c  => {'ReportSample::Simple' => mnames_for([:class_m_1])}
  end

  # Note: test all in 1 go because testing in bits would fail, and it differs from real usage.
  xit 'simple case : all calls are internal' do
    ReportSample::Simple      .new.make_internal_calls
    the_report = PrivatePlease.report

    {
        :good_candidates    => the_report.good_candidates,
       #:good_candidates_c  => the_report.good_candidates_c,
        :bad_candidates   => the_report.bad_candidates,
        :bad_candidates_c => the_report.bad_candidates_c,
        #:ignored          => the_report.never_called_candidates,
        #:ignored_c        => the_report.never_called_candidates_c
    }.should == {
        :good_candidates  => {
            'ReportSample::Simple'   =>  mnames_for([:instance_m_1, :instance_m_2])
        },
        :bad_candidates   => {},
        :bad_candidates_c => {},
        #:ignored          => {
        #    'ReportSample::Simple'   =>  mnames_for([:never_called_1])
        #},
#:good_candidates_c => {
#    'ReportSample::Simple'   =>  mnames_for([:good_candidate_c2])
#},
#:ignored_c => {
#    'ReportSample::Simple'   =>  mnames_for([:good_candidate_c2])
#},
        #:ignored_c        => {
        #    'ReportSample::Simple'   =>  mnames_for([:class_never_called_1])
        #},
    }
  end
end
__END__
  xit 'simple case : all calls are internal' do
    ReportSample::Simple      .new.make_internal_calls
    ReportSample::AnotherClass.new.make_external_calls
    the_report = PrivatePlease.report
    {
        :good_candidates  => the_report.good_candidates,
        #:bad_candidates   => the_report.bad_candidates,
        #:bad_candidates_c => the_report.bad_candidates_c,
        #:ignored          => the_report.never_called_candidates
    }.should == {
        :good_candidates  => {
            'ReportSample::Simple'   =>  mnames_for([:instance_m_2])
        },
        #:good_candidates_c => {
        #    'ReportSample::Simple'   =>  mnames_for([:good_candidate_c2])
        #},
        #        :bad_candidates   => {
        #            'ReportSample::Simple'   =>  mnames_for([:bad_candidate_3, :bad_candidate_6]),
        #            'ReportSample::Simple2'  =>  mnames_for([:bad_candidate_too])
        #        },
        #        :bad_candidates_c => {
        #            'ReportSample::Simple'   =>  mnames_for([:bad_candidate_c3]),
        #            'ReportSample::Simple2'  =>  mnames_for([:bad_candidate_c_too])
        #        },
        #        :ignored          => {
        #            'ReportSample::Simple'   =>  mnames_for([:ignored_8]),    #TODO : uniformize (it currently mixes Sets & Arrays)
        #            'ReportSample::Simple2'  =>  mnames_for([:ignored_2])
        #        }
    }
  end
end