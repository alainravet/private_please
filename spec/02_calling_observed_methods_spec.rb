require 'spec_helper'

describe PrivatePlease, 'CallingTest observed methods and separating the outside/inside calls' do
  before() do
    PrivatePlease.activate(true)
  end
  let(:storage) { PrivatePlease.storage }

  module CallingTest
    class Simple
      def public_m ;  private_m()   end
      def private_m; 'SUCCESS'      end  # << observed method
      private_please  :private_m
    end
  end

#--------------
  context 'from INSIDE the class' do
#--------------

    before { CallingTest::Simple.new.public_m }

    it('records the call to the observed method in PrivatePlease.inside_called_candidates') do
      storage.inside_called_candidates .should == {'CallingTest::Simple' => [:private_m]}
      storage.outside_called_candidates.should == {}
    end

    it('records multiple calls only once') do
      2.times{ CallingTest::Simple.new.public_m }
      storage.inside_called_candidates .should == {'CallingTest::Simple' => [:private_m]}
      storage.outside_called_candidates.should == {}
    end
  end


#--------------
  context 'from OUTSIDE the class' do
#--------------

    before { @result = CallingTest::Simple.new.private_m }

    it 'goes thru (as the method is still public)' do
      @result.should == 'SUCCESS'
    end

    it('records the call to the observed method in PrivatePlease.outside_called_candidates') do
      storage.inside_called_candidates .should == {}
      storage.outside_called_candidates.should == {'CallingTest::Simple' => [:private_m]}
    end

    it('records multiple calls only once') do
      2.times{ CallingTest::Simple.new.private_m }
      storage.inside_called_candidates .should == {}
      storage.outside_called_candidates.should == {'CallingTest::Simple' => [:private_m]}
    end
  end

end