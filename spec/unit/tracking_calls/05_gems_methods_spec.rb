require 'spec_helper'

# FIXTURE : ------------------------------------------------------------------

require 'sinatra/base'

class FakeGravatarServer < Sinatra::Base
end

# TESTS : ------------------------------------------------------------------

describe PrivatePlease::MethodsCallsTracker, '.privatazable_methods' do
  before do
    PrivatePlease.start_tracking
  end

  context 'when a gem method is called' do
    it 'works with Sinatra' do
      FakeGravatarServer.new

      assert_result_is_empty
    end
  end
end
