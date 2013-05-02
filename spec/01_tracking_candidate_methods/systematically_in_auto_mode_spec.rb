require 'spec_helper'

describe PrivatePlease, 'in $automatic mode, all the methods are tracked for observation by PP' do

  before { $automatic_private_please_tracking = true }
  after  { $automatic_private_please_tracking = false}

  let(:candidates_store) { PrivatePlease.storage }

# ----------------
  context 'in a flat class,' do  # simple class; no module nor inheritance
# ----------------
    module AutFlatClass; end

    example 'instance and singleton methods are tracked' do
      class AutFlatClass::Case1
        def foo      ; end     #
        def baz      ; end     #
        def self.foo ; end     #
        def self.baz ; end     #
      end

      assert_instance_methods_candidates    'AutFlatClass::Case1' => [:baz, :foo]
      assert_singleton_methods_candidates   'AutFlatClass::Case1' => [:baz, :foo]
    end


    example '.included and #included are 2 methods we track in classes.' do
      class AutFlatClass::Case2
        def foo           ; end     #

        def self.baz      ; end     # 
      end

      assert_instance_methods_candidates    'AutFlatClass::Case2' => [:foo]
      assert_singleton_methods_candidates   'AutFlatClass::Case2' => [:baz]
    end


    example 'already private methods are not tracked' do
      class AutFlatClass::Case3
        def foo       ; end                 #    YES
        def self.baz  ; end                 #    YES
      private
        def already_private         ; end   #    NO
        class << self
        private
          def class_already_private ; end   #    NO
        end
      end

      assert_instance_methods_candidates    'AutFlatClass::Case3' => [:foo]
      assert_singleton_methods_candidates   'AutFlatClass::Case3' => [:baz]
    end

    example 'metaprograpping-related Class methods are not tracked' do
      class AutFlatClass::Case4
        def singleton_method_added(_) ; end #    NO
        def method_added(          _) ; end #    NO
      end

      assert_instance_methods_candidates    ({})
      assert_singleton_methods_candidates   ({})
    end
  end

# ----------------
  context 'in a flat module,' do  # no inheritance
# ----------------
    module AutFlatModule; end

    example 'instance and singleton methods are tracked' do
      module AutFlatModule::Case1
        def foo      ; end     #
        def self.baz ; end     #
      end

      assert_instance_methods_candidates    'AutFlatModule::Case1' => [:foo]
      assert_singleton_methods_candidates   'AutFlatModule::Case1' => [:baz]
    end

    example 'we track #included but not .included' do
      module AutFlatModule::Case2
        def foo           ; end     #
        def included      ; end     # : not a special name in classes

        def self.baz      ; end     # 
        def self.included ; end     # : not a special name in classes
      end

      assert_instance_methods_candidates    'AutFlatModule::Case2' => [:foo, :included]
      assert_singleton_methods_candidates   'AutFlatModule::Case2' => [:baz]
    end


    example 'already private methods are not tracked' do
      module AutFlatModule::Case3
      private
        def already_private         ; end   #    NO
        class << self
        private
          def class_already_private ; end   #    NO
        end
      end

      assert_instance_methods_candidates    ({})
      assert_singleton_methods_candidates   ({})
    end

    example 'metaprograpping-related Module methods are not tracked' do
      module AutFlatModule::Case4
        def singleton_method_added(_) ; end #    NO
        def method_added(          _) ; end #    NO
        def self.included(base)       ; end #    NO
      end

      assert_instance_methods_candidates    ({})
      assert_singleton_methods_candidates   ({})
    end

  end


# ----------------
  context '1 class including 1 module' do
# ----------------
    module IncludedModule ; end
    
    example 'the tracked module methods are associated to the module, not the class(es) that includes the module' do
      module IncludedModule
        module Module1                    #
          def im_from_module ; end        # YES
          def self.included(base)         # NO
            base.extend ClassMethods      #
          end                             #
          module ClassMethods             #
            def cm_from_module ; end      # YES
          end                             #
        end                               #
        class Case1
          include Module1                 # NO methods are associated to this class. 
        end
      end
      
      assert_instance_methods_candidates 'IncludedModule::Module1'                  =>[:im_from_module],
                                         'IncludedModule::Module1::ClassMethods'    =>[:cm_from_module]
      assert_singleton_methods_candidates    ({})
    end

  end


# ----------------
  describe 'overridden methods are not tracked in classes' do
# ----------------
    module ImplOverridingTest ; end
    
    example 'overridden methods are NOT marked as candidate' do
      module ImplOverridingTest
        class Base  
          def base_t_foo        ; end # is tracked
          def self.c_base_t_foo ; end # is tracked
        private
          def base_priv         ; end # private => not tracked
        end

        class Overrider < Base
          def base_priv         ; end   # overriding a private method => not tracked
          def base_yes          ; end   # new -> tracked
          def self.c_base_yes   ; end   # new -> tracked
        
          def base_t_foo        ; end   # NOT tracked
          def self.c_base_t_foo ; end   # NOT tracked
          
          def to_s              ; end   # NOT tracked
        end
      end

      assert_instance_methods_candidates 'ImplOverridingTest::Base'      => [:base_t_foo],
                                         'ImplOverridingTest::Overrider' => [:base_yes]
      assert_class_methods_candidates    'ImplOverridingTest::Base'      => [:c_base_t_foo],
                                         'ImplOverridingTest::Overrider' => [:c_base_yes]
    end
  end


end
