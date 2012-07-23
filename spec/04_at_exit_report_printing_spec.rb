require 'spec_helper'

describe 'calling marked methods' do

  module Report
    class Simple
      def public_m ;  private_m()     end
      def private_m;  'SUCCESS'       end
      def ignored  ;  'never called'  end
      private_please  :private_m, :ignored
    end
  end

  before do
    Calling::Simple.new.public_m
    Calling::Simple.new.private_m
    @report = PrivatePlease.report
  end

  it('lists the candidates that were only called from the inside')
  it('lists the candidates that were called from the inside')
  it('lists the candidates that were never called')

  specify 'at_exit prints the report in the STDOUT'

end