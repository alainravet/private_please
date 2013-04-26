require 'spec_helper'


describe PrivatePlease::Storage::CallsStore do

  let(:calls_store     )  { PrivatePlease::Storage::CallsStore.new }

  context 'when fresh' do
    it 'is empty (has no calls)' do
      calls_store.internal_calls       .should be_empty
      calls_store.external_calls       .should be_empty
    end
  end

end
