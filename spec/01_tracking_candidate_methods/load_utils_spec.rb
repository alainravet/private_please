require 'spec_helper'

describe PrivatePlease::Tracking::LoadUtils do

  def std_lib?(requiree)
    PrivatePlease::Tracking::LoadUtils.standard_lib?(requiree)
  end

  example '.standard_lib? detects if a string matches a standard library' do
    std_lib?('csv'                ).should be_true
    std_lib?('csv.rb'             ).should be_true
    std_lib?('bigdecimal'         ).should be_true
    std_lib?('bigdecimal/util'    ).should be_true
    std_lib?('bigdecimal/util.rb' ).should be_true

    std_lib?('rspec'              ).should be_false
    std_lib?('private_please'     ).should be_false
  end


end
