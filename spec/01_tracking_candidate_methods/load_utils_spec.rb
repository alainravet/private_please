require 'spec_helper'

describe PrivatePlease::Tracking::LoadUtils do

  def std_lib?(requiree)
    PrivatePlease::Tracking::LoadUtils.standard_lib?(requiree)
  end

  def gem?(requiree)
    PrivatePlease::Tracking::LoadUtils.gem?(requiree)
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

  example '.gem? detects if a string matches a gem' do
    gem?('csv'                ).should be_false
    gem?('csv.rb'             ).should be_false
    gem?('bigdecimal'         ).should be_false
    gem?('bigdecimal/util'    ).should be_false
    gem?('bigdecimal/util.rb' ).should be_false

    gem?('rspec'              ).should be_true
    gem?('rspec/core/rake_task').should be_true
    gem?('rspec/autorun'      ).should be_true
    gem?('coderay'            ).should be_true
   #gem?('private_please'     ).should be_false
  end


end
