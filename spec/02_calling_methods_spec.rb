require 'spec_helper'

describe PrivatePlease, 'calling marked methods' do
  before() do
    PrivatePlease.activate(true)
  end

  module Calling
    class Simple
      def public_m ;  private_m()   end
      def private_m; 'SUCCESS'      end
      private_please  :private_m
    end
  end

#--------------
  context 'from INSIDE the class' do
#--------------

    before { Calling::Simple.new.public_m }

    it('records the call to the p+p method in PrivatePlease.inside_called_candidates') do
      PrivatePlease.inside_called_candidates[ 'Calling::Simple'].to_a.should == [:private_m]
      PrivatePlease.outside_called_candidates['Calling::Simple'].to_a.should == []
    end

    it('records multiple calls only once') do
      2.times{ Calling::Simple.new.public_m }
      PrivatePlease.inside_called_candidates[ 'Calling::Simple'].to_a.should == [:private_m]
      PrivatePlease.outside_called_candidates['Calling::Simple'].to_a.should == []
    end
  end


#--------------
  context 'from OUTSIDE the class' do
#--------------

    before { @result = Calling::Simple.new.private_m }

    it 'goes thru (as the method is still public)' do
      @result.should == 'SUCCESS'
    end

    it('records the call to the p+p method in PrivatePlease.inside_called_candidates') do
      PrivatePlease.inside_called_candidates[ 'Calling::Simple'].to_a.should == []
      PrivatePlease.outside_called_candidates['Calling::Simple'].to_a.should == [:private_m]
    end

    it('records multiple calls only once') do
      2.times{ Calling::Simple.new.private_m }
      PrivatePlease.inside_called_candidates[ 'Calling::Simple'].to_a.should == []
      PrivatePlease.outside_called_candidates['Calling::Simple'].to_a.should == [:private_m]
    end
  end

end