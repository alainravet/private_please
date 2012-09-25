require 'spec_helper'

describe PrivatePlease, 'marking methods to observe' do

  before { PrivatePlease.activate(true) }

  let(:storage) { PrivatePlease.storage }

# ----------------
  context 'explicitely, 1 by 1, with the `private_please` command' do
# ----------------

    it('associates the marked methods and their owning class, and stores them in the `candidates list') do
      class MarkingTest::Simple1
        def foo ; 'foo' end
        def bar ; 'bar' end
        def buz ; 'bar' end
        private_please  :bar, :buz    # <<-- what we test
      end

      assert_observed 'MarkingTest::Simple1' =>[:bar, :buz]
    end


    it('rejects invalid candidates (method not found in the class)') do

      class MarkingTest::Simple2
        def foo ; 'foo' end
        private_please  :foo               # <<-- what we test
        private_please  :invalid_method    # <<-- what we test
      end

      assert_observed 'MarkingTest::Simple2' =>[:foo]
    end
  end

# ----------------
  context 'automatically' do
# ----------------

    specify 'with a parameterless `private_please` call' do

      class MarkingTest::Automatic1
        def foo ; end
      private_please
        def baz ; end
      public
        def qux ; end
      end

      assert_observed 'MarkingTest::Automatic1' =>[:baz, :qux]
    end


    specify 'with include PrivatePlease::Automatic' do

      class MarkingTest::Automatic2
        def foo ; end
        def bar ; end
        include PrivatePlease::Automatic
        def baz ; end
      protected
        def qux ; end
      end

      assert_observed 'MarkingTest::Automatic2' =>[:baz, :qux]
    end

  end

end