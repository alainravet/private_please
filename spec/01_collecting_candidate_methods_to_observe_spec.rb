require 'spec_helper'

describe PrivatePlease, 'collecting the candidate-methods to observe' do

  before { PrivatePlease.activate(true) }

  let(:storage) { PrivatePlease.storage }

# ----------------
  context 'observing with `private_please(<method names>)`' do
# ----------------

    it('stores the methods names in the candidates list, indexed by their owning class') do
      class MarkingTest::Simple1
        def foo ; 'foo' end
        def bar ; 'bar' end
        def buz ; 'bar' end
        private_please  :bar, 'buz'    # <<-- what we test
      end

      assert_candidates 'MarkingTest::Simple1' =>[:bar, :buz]
    end


    it('ignores invalid candidates (method not found in the class)') do
      class MarkingTest::Simple2
        def found ; 'foo' end
        private_please  :found             # <<-- valid
        private_please  :not_found_method  # <<-- not found => INvalid
      end

      assert_candidates 'MarkingTest::Simple2' =>[:found]
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
      assert_candidates 'MarkingTest::Automatic1' =>[:baz, :qux]
    end
  end


# ----------------
  context 'observing with `include PrivatePlease::AllBelow`' do
# ----------------

    example 'all the methods defined subsequently are stored as candidates' do

      class MarkingTest::Automatic2
        def foo ; end
        def bar ; end
        include PrivatePlease::AllBelow # ---> # <start>
        def baz ; end                          #    *
      protected                                #    *
        def qux ; end                          #    *
      end

      assert_candidates 'MarkingTest::Automatic2' =>[:baz, :qux]
    end

  end

end