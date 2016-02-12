require 'spec_helper'

# FIXTURE : ------------------------------------------------------------------

module IncludedModule
  def self.self_a
    self_b
  end

  def self.self_b
    self_c
  end
  class << self
    private
    def self_c ; end # already_private
  end

  def inc_public
    inc_privatazable
  end

  def inc_public_bis
    IncludedModule.self_a
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
          '#inc_privatazable' => [__FILE__, 26]
        }
      )
    end

    it 'finds the included privatazable self.methods' do
      OneModuleMethod.new.inc_public_bis

      assert_result_equal(
        IncludedModule => {
          '.self_b' => [__FILE__, 10],
        }
      )
    end

    it 'finds the extended privatazable methods' do
      OneModuleMethod.k_public

      assert_result_equal(
        ExtendedModule => {
          '#ext_public' =>           [__FILE__, 31],
          '#ext_privatazablext_2' => [__FILE__, 34]
        }
      )
    end
  end
end
