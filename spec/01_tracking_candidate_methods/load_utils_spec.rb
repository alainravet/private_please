require 'spec_helper'

describe PrivatePlease::Tracking::LoadUtils do

  def std_lib?(requiree)
    PrivatePlease::Tracking::LoadUtils.standard_lib?(requiree)
  end

  def gem?(requiree)
    PrivatePlease::Tracking::LoadUtils.gem?(requiree)
  end


  example '.standard_lib? detects if a string matches a standard library' do
    std_lib?('csv'                ).should be_truthy
    std_lib?('csv.rb'             ).should be_truthy
    std_lib?('bigdecimal'         ).should be_truthy
    std_lib?('bigdecimal/util'    ).should be_truthy
    std_lib?('bigdecimal/util.rb' ).should be_truthy

    std_lib?('rspec'              ).should be_falsey
    std_lib?('private_please'     ).should be_falsey
    std_lib?('/an/abs/path/csv'   ).should be_falsey
    std_lib?('../csv'             ).should be_falsey
    std_lib?('lib/../csv'         ).should be_falsey
  end

  example '.gem? detects if a string matches a gem' do
    gem?('csv'                ).should be_falsey
    gem?('csv.rb'             ).should be_falsey
    gem?('bigdecimal'         ).should be_falsey
    gem?('bigdecimal/util'    ).should be_falsey
    gem?('bigdecimal/util.rb' ).should be_falsey

    gem?('rspec'              ).should be_truthy
    gem?('rspec/core/rake_task').should be_truthy
    gem?('rspec/autorun'      ).should be_truthy
    gem?('coderay'            ).should be_truthy
    gem?('lib/../rspec'       ).should be_truthy  # same as gem?('rspec')

    gem?('/an/abs/path/rspec' ).should be_falsey
    gem?('../rspec'           ).should be_falsey
    gem?('rspec/../lib/foo'   ).should be_falsey
  end

end
