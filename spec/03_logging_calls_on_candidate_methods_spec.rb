require 'spec_helper'

describe PrivatePlease, 'calling observed methods and logging calls in 2 categories : internal or external' do

  before do
#-----------------------------------------------------------------------------------------------------------------------
    load File.dirname(__FILE__) + '/fixtures/sample_class_with_all_calls_combinations.rb'
#-----------------------------------------------------------------------------------------------------------------------
  end
  after { Object.send(:remove_const, :CallsSample) }

  example ('pure internal calls are categorized correctly') do
    CallsSample::Simple.new.make_internal_calls
    assert_calls_detected :inside     => {'CallsSample::Simple' => mnames_for([:instance_m_1, :instance_m_2])},
                          :outside    => NO_CALLS_OBSERVED,
                          :inside_c   => {'CallsSample::Simple' => mnames_for([:class_m_1, :class_m_2])},
                          :outside_c  => NO_CALLS_OBSERVED
  end

  example ('pure external calls are categorized correctly') do
    CallsSample::AnotherClass.new.make_external_calls
    assert_calls_detected :inside     => NO_CALLS_OBSERVED,
                          :outside    => {'CallsSample::Simple' => mnames_for([:instance_m_1])},
                          :inside_c   => {'CallsSample::Simple' => mnames_for([:class_m_2])},
                          :outside_c  => {'CallsSample::Simple' => mnames_for([:class_m_1])}
  end

  example('when a method is called both from inside and from outside its class, it is recorded is both categories') do
    CallsSample::AnotherClass.new.call_the_candidate_from_inside_and_outside
    assert_calls_detected :inside     => {'CallsSample::Simple' => mnames_for([:instance_m_1, :instance_m_2])},
                          :outside    => {'CallsSample::Simple' => mnames_for([:instance_m_1])},
                          :inside_c   => {'CallsSample::Simple' => mnames_for([:class_m_2, :class_m_1])},
                          :outside_c  => {'CallsSample::Simple' => mnames_for([:class_m_1])}
  end

  example('BUG #41') do
    CallsSample::Fail.new.bad_candidate_1
    CallsSample::Good.new.bad_candidate_1
pending "bug #41 is fixed" do
    assert_calls_detected :inside     => {'CallsSample::Fail' => mnames_for([:bad_candidate_1])},
                          :outside    => {'CallsSample::Fail' => mnames_for([:bad_candidate_1]),
                                          'CallsSample::Good' => mnames_for([:bad_candidate_1])
                          },
                          :inside_c   => NO_CALLS_OBSERVED,
                          :outside_c  => NO_CALLS_OBSERVED
end
  end

#-----------------------------------------------------------------------------------------------------------------------
end
