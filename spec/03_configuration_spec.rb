require 'spec_helper'

describe PrivatePlease, 'configuration options and defaults' do

  before() { PrivatePlease.install }

#--------------

  it('is inactive by default') { PrivatePlease.should_not be_active }

  it('is activated with #activate()') do
    PrivatePlease.activate         ; PrivatePlease.should     be_active
    PrivatePlease.activate(false)  ; PrivatePlease.should_not be_active
  end


  before do
#-----------------------------------------------------------------------------------------------------------------------
    require File.dirname(__FILE__) + '/fixtures/sample_class_with_all_calls_combinations'
#-----------------------------------------------------------------------------------------------------------------------
  end

  example ('when inactive, no calls are recorded') do
    PrivatePlease.activate(false)
    CallsSample::Simple      .new.make_internal_calls
    CallsSample::AnotherClass.new.make_external_calls

    assert_no_calls_detected
  end

end
