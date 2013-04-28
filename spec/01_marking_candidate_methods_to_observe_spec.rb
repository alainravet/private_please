require 'spec_helper'

describe PrivatePlease, 'collecting the details of candidate-methods to observe' do
  module MarkingTest; end

  let(:candidates_store) { PrivatePlease.storage }

# ----------------
  context 'observing with `private_please(<method names>)`' do
# ----------------

    it('stores the instance methods names in the candidates list, indexed by their owning class') do
      class MarkingTest::Simple1
        def foo ; 'foo' end
        def bar ; 'bar' end
        def buz ; 'bar' end
        private_please  :bar, 'buz'    # <<-- what we test
      end

      assert_instance_methods_candidates 'MarkingTest::Simple1' =>[:bar, :buz]
    end


    it('does not work with class methods') do
      class MarkingTest::Simple1b
        def self.found ; 'I am a class method' end
        private_please  :found    # <<-- class method => not observed
      end

      assert_instance_methods_candidates ({})
      assert_class_methods_candidates    ({})
    end

    it('ignores invalid candidates (method not found in the class)') do
      class MarkingTest::Simple2
        def found ; 'foo' end
        private_please  :found             # <<-- valid
        private_please  :not_found_method  # <<-- not found => INvalid
      end

      assert_instance_methods_candidates 'MarkingTest::Simple2' =>[:found]
    end

    it('ignores duplicates') do
      class MarkingTest::Simple3
        def found ; 'foo' end
        private_please  :found             #
        private_please  :found             # duplicate -> ignore
      end

      assert_instance_methods_candidates 'MarkingTest::Simple3' =>[:found]
    end
  end


# ----------------
  context 'observing with `private_please()`' do
# ----------------

    example 'all the instance methods defined after `private_please` are stored as candidates' do

      class MarkingTest::Automatic1
        def foo ; end          #    NO (too early)
      private_please # --->    # <start observing>
        def baz ; end          #    *
      public                   #    *
        def qux ; end          #    *
        def included ; end     #    * special name, but valid candidate (in classes).
      end
      assert_instance_methods_candidates 'MarkingTest::Automatic1' =>[:baz, :qux, :included]
      assert_class_methods_candidates    ({})
    end


    example 'all the class methods defined after `private_please` are stored as candidates' do
      class MarkingTest::Automatic1b
        def self.foo ; end       #    NO (too early)
      private_please   # --->    # <start observing>
        def self.baz ; end       #    YES
      public                     #    *
        def self.qux ; end       #    YES
        def self.included ; end  #    * special name, but valid candidate (in classes).
      end

      assert_instance_methods_candidates ({})
      assert_class_methods_candidates    'MarkingTest::Automatic1b' =>[:baz, :qux, :included]
    end

    example ('already private methods are ignored/not observed') do
      class MarkingTest::Automatic1c
      private_please   # --->    # <start observing>
        def self.baz ; end       #    YES
      public                     #    *
        def qux ; end            #    YES
      private                    #
        def already_private ; end            #    NO
        class << self
        private
          def class_already_private ; end     #    NO
        end
      end

      assert_instance_methods_candidates 'MarkingTest::Automatic1c' =>[:qux]
      assert_class_methods_candidates    'MarkingTest::Automatic1c' =>[:baz]
    end


    example 'method coming from an included module are observed too' do
#TODO : find a better way to instrument modules
#TODO : find a way to instrument modules automatically (? possible)

      module Extra002               ; private_please end  # <<=== Pre-instrument.
      module Extra002::ClassMethods ; private_please end  # <<=== Pre-instrument.

      module Extra002                                     # Reopen the pre-instrumented
        def im_from_module ; end                          # module.
        def self.included(base)                           #
          base.extend ClassMethods                        #
        end                                               #
        module ClassMethods                               #
          def cm_from_module ; end                        #
        end                                               #
      end                                                 #
      assert_instance_methods_candidates 'Extra002'                 =>[:im_from_module],
                                         'Extra002::ClassMethods'   =>[:cm_from_module]
      assert_class_methods_candidates    ({})
    end
  end


# ----------------
  context 'observing with `include PrivatePlease::Tracking::InstrumentsAllBelow`' do
# ----------------

    example 'all the methods defined subsequently are stored as candidates' do

      class MarkingTest::Automatic2
        def foo ; end
        def bar ; end
        include PrivatePlease::Tracking::InstrumentsAllBelow # ---> # <start observing>
        def baz ; end                          #    YES
        def self.class_m1; end                 #    YES
      protected                                #
        def qux ; end                          #    YES
      end

      assert_instance_methods_candidates 'MarkingTest::Automatic2' =>[:baz, :qux]
      assert_class_methods_candidates    'MarkingTest::Automatic2' =>[:class_m1]
    end

  end

end