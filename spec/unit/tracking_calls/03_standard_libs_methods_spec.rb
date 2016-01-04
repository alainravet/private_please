require 'spec_helper'

# FIXTURE : ------------------------------------------------------------------

require 'csv'
class StandardLibFooBar
  def public_method
    privatazable_1
  end

  def privatazable_1
    CSV.parse('this,is,my,data') # don't trace CSV calls
  end
end

# TESTS : ------------------------------------------------------------------

describe PrivatePlease::MethodsCallsTracker, '.privatazable_methods' do
  before do
    PrivatePlease.start_tracking
  end

  context 'when a standard lib method is called' do
    it 'is excluded from the final report' do
      StandardLibFooBar.new.public_method

      assert_result_equal(
        StandardLibFooBar => {
          '#privatazable_1' => [__FILE__, 11]
        }
      )
    end
  end
end
