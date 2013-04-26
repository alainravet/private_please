require 'spec_helper'

describe PrivatePlease, 'collecting the details of candidate-methods to observe' do
  module MarkingTest; end

  before { PrivatePlease.activate(true) }

  let(:candidates_db) { PrivatePlease.storage }

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

    example 'all the methods defined subsequently are stored as candidates' do

      class MarkingTest::Automatic1
        def foo ; end
      private_please # ---> # <start>
        def baz ; end       #    *
      public                #    *
        def qux ; end       #    *
      end
      assert_instance_methods_candidates 'MarkingTest::Automatic1' =>[:baz, :qux]
    end


    example 'class methods are observed too' do
      class MarkingTest::Automatic1b
        def self.foo ; end       #    NO (too early)
      private_please   # --->    # <start observing>
        def self.baz ; end       #    YES
      public                     #    *
        def self.qux ; end       #    YES
      #private                    # FIXME : exclude methods that are already private
      #  def self.already_private ; end #    NO
      end

      assert_instance_methods_candidates ({})
      assert_class_methods_candidates    'MarkingTest::Automatic1b' =>[:baz, :qux]
    end
  end


# ----------------
  context 'observing with `include PrivatePlease::Tracking::AllBelow`' do
# ----------------

    example 'all the methods defined subsequently are stored as candidates' do

      class MarkingTest::Automatic2
        def foo ; end
        def bar ; end
        include PrivatePlease::Tracking::AllBelow # ---> # <start observing>
        def baz ; end                          #    YES
        def self.class_m1; end                 #    YES
      protected                                #
        def qux ; end                          #    YES
      #private                    # FIXME : exclude methods that are already private
      #  def already_private ; end              #    NO
      end

      assert_instance_methods_candidates 'MarkingTest::Automatic2' =>[:baz, :qux]
      assert_class_methods_candidates    'MarkingTest::Automatic2' =>[:class_m1]
    end

  end

end