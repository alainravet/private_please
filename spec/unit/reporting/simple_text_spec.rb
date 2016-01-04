require 'spec_helper'

# FIXTURE : ------------------------------------------------------------------

class SimpleTextFoo
  class << self
    def public_c_1
      public_c_2
    end

    def public_c_2 ; end
  end

  def public_i_1
    public_i_2
  end

  def public_i_2 ; end
end

# TESTS : ------------------------------------------------------------------

describe PrivatePlease::Reporting::SimpleText, '.text' do
  expected_report = <<-REPORT
====================================================================================
=                               Privatazable methods :                             =
====================================================================================
#{__FILE__}
    11  SimpleTextFoo.public_c_2
    18  SimpleTextFoo#public_i_2
  REPORT

  before do
    PrivatePlease.track do
      SimpleTextFoo.new.public_i_1
      SimpleTextFoo.public_c_1
    end
  end

  it 'lists the privatazable methods details as a plain text' do
    PrivatePlease::Reporting::SimpleText.new(PrivatePlease.instance.result).text.should == expected_report
  end

  it "is aliased to 'PrivatePlease.report'" do
    PrivatePlease.report.should == expected_report
  end
end
