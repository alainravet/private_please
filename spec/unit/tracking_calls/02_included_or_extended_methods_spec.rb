require 'spec_helper'

# FIXTURE : ------------------------------------------------------------------

module IncludedModule
  def inc_public
    inc_privatazable
  end

  def inc_privatazable
  end
end

module ExtendedModule
  def ext_public
  end

  def ext_privatazablext_2
  end
end

class OneModuleMethod
  include IncludedModule
  extend  ExtendedModule

  def self.k_public
    ext_public
    ext_privatazablext_2
  end
end

# TESTS : ------------------------------------------------------------------

describe PrivatePlease::MethodsCallsTracker, '.privatazable_methods' do
  before do
    PrivatePlease.start_tracking
  end

  context 'when methods are defined in modules' do
    it 'finds the included privatazable methods' do
      OneModuleMethod.new.inc_public

      assert_result_equal(
        IncludedModule => {
          '#inc_privatazable' => [__FILE__, 10]
        }
      )
    end

    it 'finds the extended privatazable methods' do
      OneModuleMethod.k_public

      assert_result_equal(
        ExtendedModule => {
          '#ext_public' =>           [__FILE__, 15],
          '#ext_privatazablext_2' => [__FILE__, 18]
        }
      )
    end
  end
end
