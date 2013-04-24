require 'spec_helper'


describe PrivatePlease::Store::CallsLog do

  let(:st)  { PrivatePlease::Store.new }
  let(:calls_log     )  { st.calls_log      }

  context 'when fresh' do
    it 'is empty (has no calls)' do
      calls_log.internal_calls       .should be_empty
      calls_log.external_calls       .should be_empty
    end
  end

end
