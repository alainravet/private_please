require 'spec_helper'

describe PrivatePlease, 'collecting the details of selected candidate-methods to observe' do
  module MarkingTest; end

  let(:candidates_store) { PrivatePlease.storage }

# ----------------
  context 'observing with `private_please`' do
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
      end

      assert_instance_methods_candidates ({})
      assert_class_methods_candidates    'MarkingTest::Automatic1b' =>[:baz, :qux]
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
  describe 'overridden methods are not tracked' do
# ----------------
    module ExplOverridingTest ; end
    
    example 'overridden methods are NOT marked as candidate' do
      module ExplOverridingTest::UserClasses
        class Base                    #  
          def base_foo        ; end   #
          def self.c_base_foo ; end   #
        private_please                # <start tracking>
          def base_t_bar        ; end # is tracked
          def self.c_base_t_bar ; end # is tracked
        private
          def base_priv         ; end # private => not tracked
        end

        class Overrider < Base
        private_please                  # <start tracking>
          def base_priv         ; end   # overriding a private method => not tracked
          def base_yes          ; end   # new -> tracked
          def self.c_base_yes   ; end   # new -> tracked
        
          def base_foo          ; end   # NOT tracked
          def base_t_bar        ; end   # NOT tracked
          def self.c_base_foo   ; end   # NOT tracked
          def self.c_base_t_bar ; end   # NOT tracked
          
          def to_s              ; end   # NOT tracked
        end
      end

      assert_instance_methods_candidates 'ExplOverridingTest::UserClasses::Base'      => [:base_t_bar],
                                         'ExplOverridingTest::UserClasses::Overrider' => [:base_yes]
      assert_class_methods_candidates    'ExplOverridingTest::UserClasses::Base'      => [:c_base_t_bar],
                                         'ExplOverridingTest::UserClasses::Overrider' => [:c_base_yes]
    end
  end

end