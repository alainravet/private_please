require 'spec_helper'

# FIXTURE : ------------------------------------------------------------------

require 'rdoc/task'
require 'coderay'
class GemFooBar
  def public_method
    privatazable_1
  end

  def public_method_2
    privatazable_2
  end

  def privatazable_1
    RDoc::Task.new(rdoc: 'rdoc', clobber_rdoc: 'rdoc:clean', rerdoc: 'rdoc:force')
  end

  def privatazable_2
    CodeRay.scan('puts "Hello, world!"', :ruby).inspect # OK
    CodeRay.scan('puts "Hello, world!"', :ruby).html    # FAIL
  end
end

# TESTS : ------------------------------------------------------------------

describe PrivatePlease::MethodsCallsTracker, '.privatazable_methods' do
  before do
    PrivatePlease.start_tracking
  end

  context 'when a gem method is called' do
    it 'is excluded from the final report' do
      GemFooBar.new.public_method

      assert_result_equal(
        GemFooBar => {
          '#privatazable_1' => [__FILE__, 16],
        }
      )
    end

    it 'works with coderay' do
      GemFooBar.new.public_method_2

      assert_result_equal(
        GemFooBar => {
          '#privatazable_2' => [__FILE__, 20],
        }
      )
    end
  end
end
