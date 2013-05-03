require 'spec_helper'

describe PrivatePlease::Report::Table do
  let(:col_1) { %w(a b c) }
  let(:col_2) { %w(X Y Z) }

  def table(col_1, col_2)
    PrivatePlease::Report::Table.new(col_1, col_2)    
  end
#------------------------------------------------------------------------------
  
  it 'wraps 2 columns of data' do
    t = table(col_1, col_2)
    t.col_1.should == col_1
    t.col_2.should == col_2
  end

  it 'pads with nil whichever column is shorter' do
    table(['1'], %w(a b c)).tap do |t|
      t.col_1.should == ['1', nil, nil]
      t.col_2.should == %w(a b c)
    end
    table(%w(a b c), ['1']).tap do |t|
      t.col_1.should == %w(a b c)
      t.col_2.should == ['1', nil, nil]
    end
    
  end  

  example '#rows returns an array of [String, String]' do
    t = table(['1', '2'], col_2)
    t.rows.should == [
        ['1', 'X'],
        ['2', 'Y'],
        [nil, 'Z'],
    ]
  end

  example '#empty?' do
    table(['1', '2'], []).should_not be_empty    
    table([], ['1', '2']).should_not be_empty    
    table([], []        ).should     be_empty    
  end

  example '#longest_value_length' do
    table(['a', '12345'], ['b', 'c']).longest_value_length.should == '12345'.length     
    table(['b'], ['a', '12345']     ).longest_value_length.should == '12345'.length     
    table([], []                    ).longest_value_length.should == 0     
  end
  
end