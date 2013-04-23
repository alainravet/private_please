require 'spec_helper'

describe PrivatePlease, 'configuration options and defaults' do

  before() { PrivatePlease.install }

#--------------

  it('is inactive by default') { PrivatePlease.should_not be_active }

  it('is activated with #activate()') do
    PrivatePlease.activate         ; PrivatePlease.should     be_active
    PrivatePlease.activate(false)  ; PrivatePlease.should_not be_active
  end

#--------------

  before do
unless defined?(ConfigTest::Simple)
    module ConfigTest
      class Simple
        def call_the_candidate_from_inside
          candidate_3()
        end
      private_please
        def candidate_3; 'SUCCESS'      end
        def candidate_2; 'SUCCESS'      end
      end
      class AnotherClass
        def call_the_candidate_from_outside
          ConfigTest::Simple.new.candidate_2
        end
      end
    end
end
    def do_the_calls
      ConfigTest::Simple      .new.call_the_candidate_from_inside   # -> inside  call
      ConfigTest::AnotherClass.new.call_the_candidate_from_outside  # -> outside call
    end
  end

#--------------

  context 'when inactive' do

    before { PrivatePlease.activate(false) }

    it 'does NOT record the calls to candidates' do
      do_the_calls
      assert_calls_detected :inside  => {}, :outside => {},:inside_c  => {}, :outside_c=> {}
    end
  end

  context 'when active' do

    before { PrivatePlease.activate(true) }
    before { do_the_calls }

    it 'DOES record the calls to candidates' do
      do_the_calls
      assert_calls_detected :inside     => {'ConfigTest::Simple' => mnames_for([:candidate_3])},
                            :outside    => {'ConfigTest::Simple' => mnames_for([:candidate_2])},
                            :inside_c   => {},
                            :outside_c  => {}
    end
  end
end
