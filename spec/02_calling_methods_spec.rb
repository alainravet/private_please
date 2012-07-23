require 'spec_helper'

describe 'calling marked methods' do

  module Calling
    class Simple
      def public_m ;  private_m()   end
      def private_m; 'foo'          end
      private_please  :private_m
    end
  end

#--------------
  context 'from INSIDE the class' do
#--------------

    before { Calling::Simple.new.public_m }

    it('records the call to the p+p method in PrivatePlease.inside_called_candidates') do

      PrivatePlease.inside_called_candidates[ 'Calling::Simple'].to_a.should == [:private_m]
    end

    it('records multiple calls only once') do
      2.times{ Calling::Simple.new.public_m }
      PrivatePlease.inside_called_candidates[ 'Calling::Simple'].to_a.should == [:private_m]
    end
  end
end