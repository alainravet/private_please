require 'spec_helper'

describe PrivatePlease::Reporter::DataCompiler do

  context 'report generation for different scenarios' do
    after  { $expected_results = nil }

    example('simple_case_1') { assert_report_data_matches(run_and_inspect("simple_case_1.rb", __FILE__)) }
    example('simple_case_2') { assert_report_data_matches(run_and_inspect("simple_case_2.rb", __FILE__)) }
  end

end
